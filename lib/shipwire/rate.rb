module Shipwire
  class Rate < Api
    def find(body)
      request(:post, 'rate', body: body)
    end
  end
end
