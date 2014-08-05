module Shipwire
  class Configuration
    attr_accessor :endpoint, :username, :password, :server

    def initialize(&block)
      block.call(self)
    end
  end
end
