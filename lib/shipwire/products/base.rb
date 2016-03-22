module Shipwire
  class Products::Base < Products
    protected

    def product_classification
      { classification: "baseProduct" }
    end
  end
end
