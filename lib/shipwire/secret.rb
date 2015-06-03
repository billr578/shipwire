module Shipwire
  class Secret < Api
    def list
      request(:get, 'secret')
    end

    def create
      request(:post, 'secret')
    end

    def find(id)
      request(:get, "secret/#{id}")
    end

    def remove(id)
      request(:delete, "secret/#{id}")
    end
    alias_method :delete, :remove
  end
end
