module Shipwire
  class Orders < Api
    def list(params = {})
      request(:get, 'orders', params: params)
    end

    def create(payload)
      request(:post, 'orders', payload: payload)
    end

    def find(id, params = {})
      request(:get, "orders/#{id}/trackings", params: params)
    end

    def update(id, payload, params = {})
      request(:put, "orders/#{id}", payload: payload, params: params)
    end

    def cancel(id)
      request(:post, "orders/#{id}/cancel")
    end

    def holds(id, params = {})
      request(:get, "orders/#{id}/holds", params: params)
    end

    def items(id)
      request(:get, "orders/#{id}/items")
    end

    def returns(id)
      request(:get, "orders/#{id}/returns")
    end

    def trackings(id)
      request(:get, "orders/#{id}/trackings")
    end
  end
end
