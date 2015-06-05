require 'faraday'

require 'shipwire/version'
require 'shipwire/configuration'
require 'shipwire/deep_open_struct'
require 'shipwire/param_converter'
require 'shipwire/api'

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
    attr_writer :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
