module Shipwire
  module Products
    class Insert < Base
      protected

      def payload_override
        { classification: "marketingInsert" }
      end
    end
  end
end
