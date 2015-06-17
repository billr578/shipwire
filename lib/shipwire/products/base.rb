module Shipwire
  module Products
    class Base < Api
      def list(params = {})
        request(:get, 'products', {}, params)
      end

      def create(payload)
        request(:post, 'products', payload_runner(payload))
      end

      def find(id)
        request(:get, "products/#{id}")
      end

      def update(id, payload)
        request(:put, "products/#{id}", payload_runner(payload))
      end

      def retire(id)
        request(:post, 'products/retire', retire_object(id))
      end

      protected

      def product_classification; end

      private

      def payload_runner(payload)
        [payload].flatten.each_with_object([]) do |item, pl|
          pl << payload_abridge(item)
        end
      end

      def payload_abridge(payload)
        classification = product_classification || {}

        data          = RecursiveOpenStruct.new(payload).to_h
        data_override = RecursiveOpenStruct.new(classification).to_h

        data.deep_merge(data_override)
      end

      def retire_object(obj)
        retire_array = obj.is_a?(Array) ? obj : Utility.split_to_integers(obj)

        { ids: retire_array }
      end
    end
  end
end
