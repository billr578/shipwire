module Shipwire
  module Products
    class Basic < Base
      private

      def payload_override
        { classification: "baseProduct" }
      end
    end
  end
end
