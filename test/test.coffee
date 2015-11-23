should = (require 'chai').should()

compulsory = require '../lib'

describe 'compulsory', ->
  it 'should require existing modules correctly', ->
    mod = compulsory 'mod',
      cwd: __dirname + '/fixtures/project'
    mod.should.eq 42

  it 'should install missing modules automatically', ->
    exec = compulsory 'exec',
      cwd: __dirname + '/fixtures/project-package-json'
    should.exist exec.version
