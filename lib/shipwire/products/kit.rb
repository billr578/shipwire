module Shipwire
  class Products::Kit < Products
    protected

    def product_classification
      { classification: "kit" }
    end
  end
end
