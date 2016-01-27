module Shipwire
  class Webhooks < Api
    def list
      request(:get, 'webhooks')
    end

    def create(body)
      request(:post, 'webhooks', body: body)
    end

    def find(id)
      request(:get, "webhooks/#{id}")
    end

    def update(id, body)
      request(:put, "webhooks/#{id}", body: body)
    end

    def remove(id)
      request(:delete, "webhooks/#{id}")
    end
    alias_method :delete, :remove
  end
end
