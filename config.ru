$stdout.sync = $stderr.sync = true

require "bundler/setup"
Bundler.require

require "./lib/registry"
require "rack"

run Registry::App
