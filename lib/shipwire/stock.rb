module Shipwire
  class Stock < Api
    def list(params = {})
      request(:get, 'stock', {}, params)
    end
  end
end
