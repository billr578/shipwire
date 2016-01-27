module Shipwire
  class Receivings < Api
    def list(params = {})
      request(:get, 'receivings', params: params)
    end

    def create(body)
      request(:post, 'receivings', body: body)
    end

    def find(id, params = {})
      request(:get, "receivings/#{id}", params: params)
    end

    def update(id, body, params = {})
      request(:put, "receivings/#{id}", body: body, params: params)
    end

    def cancel(id)
      request(:post, "receivings/#{id}/cancel")
    end

    def labels_cancel(id)
      request(:post, "receivings/#{id}/labels/cancel")
    end
    alias_method :label_cancel, :labels_cancel

    def holds(id, params = {})
      request(:get, "receivings/#{id}/holds", params: params)
    end

    def instructions_recipients(id)
      request(:get, "receivings/#{id}/instructionsRecipients")
    end
    alias_method :instructions, :instructions_recipients
    alias_method :recipients, :instructions_recipients

    def items(id)
      request(:get, "receivings/#{id}/items")
    end

    def shipments(id)
      request(:get, "receivings/#{id}/shipments")
    end

    def trackings(id)
      request(:get, "receivings/#{id}/trackings")
    end
  end
end
