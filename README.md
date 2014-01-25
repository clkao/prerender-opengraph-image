prerender-opengraph-image
=========================

Prerender plugin for genrating og:image from screenshot

## Usage

### Run your own prerender server with this plugin enabled:

Use server.ls for example:

    $ npm i
    $ ./node_modules/.bin/lsc server.ls

### Setup prerender-node (or other prerender clients) in your site

### Use your own prerender service endpoint

    $ export PRERENDER_SERVICE_URL=http://myprerender-server.com:3000

### Access your site

    http://prerender-enabled.example.com/?_escaped_fragment_=

You should now see the resulting html populated with og:image meta tag
linking to screenshot.

## License
MIT http://clkao.mit-license.org/
