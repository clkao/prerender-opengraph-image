require! prerender
ogimage = require \./

port = process.env.PORT || 3000

server = prerender {
  workers: process.env.PHANTOM_CLUSTER_NUM_WORKERS
  iterations: process.env.PHANTOM_WORKER_ITERATIONS || 10
  phantomArguments: ['--load-images=true', '--ignore-ssl-errors=true']
  phantomBasePort: process.env.PHANTOM_CLUSTER_BASE_PORT
  messageTimeout: process.env.PHANTOM_CLUSTER_MESSAGE_TIMEOUT
}

server.use ogimage do
  file-from-url: ({url, options, og}) -> url
  imgprefix: "http://localhost:#port/ogimages"
  cachedir: \/tmp/ogimages
server.use prerender.blacklist!

server.use prerender.removeScriptTags!

server.use prerender.httpHeaders!
#server.use prerender.s3HtmlCache!

#server.start!
server.phantom.start!
if require \cluster .isMaster
  require! http
  require! express
  app = express!
  app.use '/ogimages' express.static \/tmp/ogimages
  app.get '/ogimages/*' (req, res) -> res.send 404
  app.use server~onRequest
  <- app.listen port
  console.log "Server running on port #port"
