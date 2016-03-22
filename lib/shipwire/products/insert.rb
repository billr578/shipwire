module Shipwire
  class Products::Insert < Products
    protected

    def product_classification
      { classification: "marketingInsert" }
    end
  end
end
