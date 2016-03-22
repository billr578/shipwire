module Shipwire
  class Configuration
    attr_accessor :username,
                  :password,
                  :open_timeout,
                  :timeout,
                  :endpoint,
                  :logger

    def initialize
      @username     = nil
      @password     = nil
      @open_timeout = 2
      @timeout      = 5
      @endpoint     = "https://api.shipwire.com"
      @logger       = false
    end
  end
end
