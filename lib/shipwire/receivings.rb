module Shipwire
  class Receivings < Api
    def list(params = {})
      request(:get, 'receivings', {}, params)
    end

    def create(payload)
      request(:post, 'receivings', payload)
    end

    def find(id, params = {})
      request(:get, "receivings/#{id}", {}, params)
    end

    def update(id, payload, params = {})
      request(:put, "receivings/#{id}", payload, params)
    end

    def cancel(id)
      request(:post, "receivings/#{id}/cancel")
    end

    def labels_cancel(id)
      request(:post, "receivings/#{id}/labels/cancel")
    end
    alias_method :label_cancel, :labels_cancel

    def holds(id, params = {})
      request(:get, "receivings/#{id}/holds", {}, params)
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
