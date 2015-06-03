module Shipwire
  class Returns < Api
    def list(params = {})
      request(:get, 'returns', {}, params)
    end

    def create(payload)
      request(:post, 'returns', payload)
    end

    def find(id, params = {})
      request(:get, "returns/#{id}", {}, params)
    end

    def cancel(id)
      request(:post, "returns/#{id}/cancel")
    end

    def holds(id, params = {})
      request(:get, "returns/#{id}/holds", {}, params)
    end

    def returns(id)
      request(:get, "returns/#{id}/returns")
    end

    def trackings(id)
      request(:get, "returns/#{id}/trackings")
    end

    def labels(id)
      request(:get, "returns/#{id}/labels")
    end
  end
end
