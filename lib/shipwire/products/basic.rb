module Shipwire
  class Products::Basic < Products
    protected

    def product_classification
      { classification: "baseProduct" }
    end
  end
end
