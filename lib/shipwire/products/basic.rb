module Shipwire
  module Products
    class Basic < Base
      protected

      def payload_override
        { classification: "baseProduct" }
      end
    end
  end
end
