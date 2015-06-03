module Shipwire
  class Rate < Api
    def find(payload)
      request(:post, 'rate', payload)
    end
  end
end
