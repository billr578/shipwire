module Shipwire
  class Configuration
    attr_accessor :username,
                  :password,
                  :open_timeout,
                  :timeout,
                  :endpoint

    def initialize
      @username     = nil
      @password     = nil
      @open_timeout = 2
      @timeout      = 5
      @endpoint     = "https://api.shipwire.com"
    end
  end
end
