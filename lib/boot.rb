
ENV["RACK_ENV"] ||= "development"
require 'rubygems' unless defined?(Gem)
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require_relative 'registry'
Dir["./registry/**/*.rb"].each { |f| require f }
