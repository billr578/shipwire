module Shipwire
  class Configuration
    attr_accessor :username,
                  :password,
                  :open_timeout,
                  :timeout,
                  :endpoint,
                  :server

    def initialize
      @username     = nil
      @password     = nil
      @open_timeout = 2
      @timeout      = 5
      @endpoint     = endpoint
      @server       = server
    end

    def endpoint
      beta = Rails.env.production? ? '' : '.beta'

      "https://api#{beta}.shipwire.com"
    end

    def server
      Rails.env.production? ? 'Production' : 'Test'
    end
  end
end
