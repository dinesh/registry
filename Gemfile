source "https://rubygems.org"

ruby "2.0.0"

gem 'rack'
gem 'pg'
gem "sinatra"
gem 'sequel'
gem 'sequel_polymorphic', :github => 'dinesh/sequel_polymorphic'

gem 'sinatra-sequel'
gem "multi_json"
gem 'puma'
gem 'aws-sdk', :require => "aws/s3"

group :development do
    gem 'sqlite3'
end

group :development, :test do
  gem 'shotgun'
  gem 'mocha',  "~> 0.12.8", :require => false
  gem 'rack-test'
  gem 'rspec', '2.5.0'
  gem 'rspec-core'
  gem 'autotest'
  gem 'autotest-inotify'
end