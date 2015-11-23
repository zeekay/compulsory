exec      = (require 'executive').interactive
path      = require 'path'
readPkgUp = require 'read-pkg-up'

# Traverse up directory structure looking for package.json
readPkg = (name) ->
  res      = readPkgUp.sync()
  pkg      = res.pkg
  pkg.path = res.path
  pkg

# Determine root of project based on package.json
determineRoot = (pkg) ->
  if pkg.path?
    path.dirname pkg.path
  else
    process.cwd()

# Find version of module in package.json if possible
determineVersion = (pkg, name) ->
  unless pkg.dependencies?
    return 'latest'

  pkg.dependencies[name] ? 'latest'

# Require module safely
tryRequire = (mod) ->
  try
    require mod
  catch err
    null

# Search for module
requireSearch = (name, root) ->
  mod = tryRequire path.join root, 'node_modules', name
  return mod if mod?

  mod = tryRequire name
  return mod if mod?

# Install module
install = (name, root, version = 'latest') ->
  exec "npm install #{name}@#{version}",
    cwd: root

module.exports = (name, opts = {}) ->
  opts.silent ?= false

  console.log name

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
