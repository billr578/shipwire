require 'shipwire/version'
require 'shipwire/configuration'

require 'shipwire/service_request'
require 'shipwire/fulfillment'
require 'shipwire/shipping_rate'
require 'shipwire/tracking'
require 'shipwire/inventory'

module Shipwire
  class << self
    attr_accessor :configuration

    def configure(&block)
      @configuration = Configuration.new(&block)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def endpoint
      configuration.nil? ? nil : configuration.endpoint
    end

    def username
      configuration.nil? ? nil : configuration.username
    end

    def password
      configuration.nil? ? nil : configuration.password
    end

    def server
      configuration.nil? ? nil : configuration.server
    end
  end

  class Error < Exception; end
  class ApiEndpointNotSet < Error; end
  class ApiUsernameNotSet < Error; end
  class ApiPasswordNotSet < Error; end
  class ApiServerNotSet < Error; end
  class ServerErrorEncountered < Error; end
  class AccessDenied < Error; end
  class TrackingError < Error; end
end
