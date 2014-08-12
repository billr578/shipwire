require 'rspec'
require 'mocha/api'
require 'shipwire'

require 'dotenv'
require 'pry'
Dotenv.load

Shipwire.configure do |config|
  config.endpoint = ENV['SHIPWIRE_ENDPOINT']
  config.server = ENV['SHIPWIRE_SERVER']
  config.username = ENV['SHIPWIRE_USERNAME']
  config.password = ENV['SHIPWIRE_PASSWORD']
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.mock_framework = :mocha
end
