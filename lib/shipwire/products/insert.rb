module Shipwire
  module Products
    class Insert < Base
      private

      def payload_override
        { classification: "marketingInsert" }
      end
    end
  end
end
