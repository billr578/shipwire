module Shipwire
  class Products < Api
    def list(params = {})
      request(:get, 'products', params: params_runner(params))
    end

    def create(body)
      request(:post, 'products', body: body_runner(body))
    end

    def find(id)
      request(:get, "products/#{id}")
    end

    def update(id, body)
      request(:put, "products/#{id}", body: body_runner(body))
    end

    def retire(id)
      request(:post, 'products/retire', body: retire_object(id))
    end
    alias_method :remove, :retire
    alias_method :delete, :retire

    protected

    def product_classification
      {}
    end

    private

    def params_runner(params)
      with_product_classification(params)
    end

    def body_runner(body)
      [body].flatten.each_with_object([]) do |item, pl|
        pl << with_product_classification(item)
      end
    end

    def with_product_classification(body)
      body.merge(product_classification)
    end

    def retire_object(obj)
      retire_array = obj.is_a?(Array) ? obj : Utility.split_to_integers(obj)

      { ids: retire_array }
    end
  end
end
