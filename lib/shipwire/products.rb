module Shipwire
  class Products < Api
    def list(params = {})
      request(:get, 'products', params: params_runner(params))
    end

    def create(payload)
      request(:post, 'products', payload: payload_runner(payload))
    end

    def find(id)
      request(:get, "products/#{id}")
    end

    def update(id, payload)
      request(:put, "products/#{id}", payload: payload_runner(payload))
    end

    def retire(id)
      request(:post, 'products/retire', payload: retire_object(id))
    end

    protected

    def product_classification; end

    private

    def params_runner(params)
      classification = product_classification || {}

      data          = RecursiveOpenStruct.new(params).to_h
      data_override = RecursiveOpenStruct.new(classification).to_h

      data.deeper_merge(data_override)
    end

    def payload_runner(payload)
      [payload].flatten.each_with_object([]) do |item, pl|
        pl << payload_abridge(item)
      end
    end

    def payload_abridge(payload)
      classification = product_classification || {}

      data          = RecursiveOpenStruct.new(payload).to_h
      data_override = RecursiveOpenStruct.new(classification).to_h

      data.deeper_merge(data_override)
    end

    def retire_object(obj)
      retire_array = obj.is_a?(Array) ? obj : Utility.split_to_integers(obj)

      { ids: retire_array }
    end
  end
end
