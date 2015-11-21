exec      = (require 'executive').interactive
path      = require 'path'
readPkgUp = require 'readPkgUp'

readPkg = (name) ->
  {pkg, path} = readPkgUp.sync()
  pkg.path = path
  pkg

determineRoot = (pkg) ->
  if pkg.path?
    path.dirname pkg.path
  else
    process.cwd()

determineVersion = (pkg, name) ->
  unless pkg.dependencies?
    return 'latest'

  pkg.dependencies[name] ? 'latest'

tryRequire = (path) ->
  try
    require path
  catch err
    null

requireSearch = (name, root) ->
  mod = tryRequire path.join root, 'node_modules', name
  return mod if mod?

  mod = tryRequire name
  return mod if mod?

install = (name, root, version = 'latest') ->
  exec "npm install #{name}@#{version}",
    cwd: root

module.exports = (name, opts = {}) ->
  opts.silent ?= false

  # Get package.json, determine project root, determine version to install
  pkg     = readPkg()
  root    = opts.cwd     ? (determineRoot pkg)
  version = opts.version ? (determineVersion pkg, name)

  # Search for module
  mod = requireSearch name, root

  unless mod?
    # Unable to find module, install it
    install name, root, version

  tryRequire name
