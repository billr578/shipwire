require 'faraday'
require 'recursive_open_struct'

require 'shipwire/version'
require 'shipwire/api'
require 'shipwire/configuration'
require 'shipwire/param_converter'
require 'shipwire/response'

require 'shipwire/orders'
require 'shipwire/rate'
require 'shipwire/receivings'
require 'shipwire/returns'
require 'shipwire/secret'
require 'shipwire/stock'
require 'shipwire/webhooks'

require 'shipwire/products/base'
require 'shipwire/products/basic'
require 'shipwire/products/insert'
require 'shipwire/products/kit'
require 'shipwire/products/virtual_kit'

module Shipwire
  class << self
    attr_accessor :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
