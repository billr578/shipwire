module Shipwire
  module Products
    class Basic < Base
      protected

      def product_classification
        { classification: "baseProduct" }
      end
    end
  end
end
