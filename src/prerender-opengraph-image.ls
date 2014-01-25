require! <[fs mv tmp mkdirp path]>

module.exports = ({imgprefix, file-from-url = -> it, cachedir = '/tmp', always}) -> do
  onPhantomPageCreate: (phantom, context, next) !->
    console.log \create
    next!
  afterPhantomRequest: (phantom, {request,response}, next) !->
    {url} = request
    {options,og} <- phantom.evaluate ->
      options = {[meta.get-attribute('property') - /^prerender:/, meta.content] for meta in document.querySelectorAll('meta[property^="prerender:"]')}
      og = {[meta.get-attribute('property') - /^og:/, meta.content] for meta in document.querySelectorAll('meta[property^="og:"]')}
      {options, og}

    unless always or options.selector
      return next!

    key = file-from-url {url, options, og}
    return next! unless key
    key -= /^https?:\/\//
    key += '.jpg'

    if options.viewport
      [width, height] = that.split \,
      phantom.set \viewportSize {width, height}
    options.key = key
    console.log options, og

    clipRect <- phantom.evaluate (({key,selector}) ->
      document.querySelector('html').className += ' prerender'
      try document.querySelector('meta[property="og:image"]').content = "#imgprefix/#key"
      return if selector
        try document.querySelector that .getBoundingClientRect!
      else
        void
    ), _, options

    response.documentHTML?.=replace /meta property="og:image" content=".*?"/ "meta property='og:image' content='#{imgprefix}/#{key}'"
    if fs.existsSync "#cachedir/#key"
      return next!

    console.log \rendering clipRect
    if clipRect
      phantom.set \clipRect clipRect{top,left,width} <<< height: Math.min clipRect.height, 630
    err, fname <- tmp.tmp-name
    <- phantom.render "#fname.jpg"
    <- mkdirp path.dirname "#cachedir/#key"
    <- mv "#fname.jpg" "#cachedir/#key"
    console.log \done "#fname.jpg", "#cachedir/#key"
    next!
  beforeSend: (req, res, next) !->
    console.log req.prerender?documentHTML?length
    next!
