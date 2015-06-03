module Shipwire
  module Products
    class Kit < Base
      private

      def payload_override
        { classification: "kit" }
      end
    end
  end
end
