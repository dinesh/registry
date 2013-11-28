
require 'bundler/setup'
require 'sinatra'

ENV['AWS_BUCKET'] = 'tech'
ENV['AWS_ACCESS_KEY'] = '123'
ENV['AWS_SECRET_KEY'] = 'abc'

Sinatra::Application.environment = :test
Bundler.require :default, Sinatra::Application.environment
require 'rspec/core'
require 'mocha'
require 'sequel'

require File.dirname(__FILE__) + '/../lib/boot'

RSpec.configure do |config|

  config.mock_framework = :mocha

  Sequel::Database.connect(Registry::App.settings.database)

  config.before(:each){
    Sequel::Model.db << "TRUNCATE #{Sequel::Model.db.tables.join(', ')} CASCADE;"
  }

end
