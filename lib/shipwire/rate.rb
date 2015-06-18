module Shipwire
  class Rate < Api
    def find(payload)
      request(:post, 'rate', payload: payload)
    end
  end
end
