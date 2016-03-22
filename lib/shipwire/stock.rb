module Shipwire
  class Stock < Api
    def list(params = {})
      request(:get, 'stock', params: params)
    end
  end
end
