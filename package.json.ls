#!/usr/bin/env lsc -cj
name: \prerender-opengraph-image
description: 'Prerender plugin for generating screenshot for opengraph image'
version: \0.0.32
repository:
  type: 'git'
  url: 'https://github.com/clkao/prerender-opengraph-image'
main: \lib/prerender-opengraph-image.js
dependencies:
  tmp: \0.0.x
  mv: \1.0.x
  mkdirp: \0.3.x
devDependencies:
  LiveScript: \1.2.x
peerDependencies:
  'prerender': \2.0.x
scripts:
  start: \app.js
  prepublish: """
    (node node_modules/LiveScript/bin/lsc -c package.json.ls || lsc -c package.json.ls || echo) &&
    lsc -bco lib src
  """
engines:
  node: '>= 0.10.x'
