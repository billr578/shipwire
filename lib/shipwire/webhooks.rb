module Shipwire
  class Webhooks < Api
    def list
      request(:get, 'webhooks')
    end

    def create(payload)
      request(:post, 'webhooks', payload)
    end

    def find(id)
      request(:get, "webhooks/#{id}")
    end

    def update(id, payload)
      request(:put, "webhooks/#{id}", payload)
    end

    def remove(id)
      request(:delete, "webhooks/#{id}")
    end
    alias_method :delete, :remove
  end
end
