module Shipwire
  class Stock < Api
    def list(params = {})
      request(:get, 'stock', params: params)
    end

    def adjust(body = {})
      request(:post, 'stock/adjust', body: body)
    end
  end
end
