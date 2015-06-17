module Shipwire
  module Products
    class Kit < Base
      protected

      def product_classification
        { classification: "kit" }
      end
    end
  end
end
