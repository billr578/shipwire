module Shipwire
  module Products
    class Insert < Base
      protected

      def product_classification
        { classification: "marketingInsert" }
      end
    end
  end
end
