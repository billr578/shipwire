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

      def payload_runner(payload)
        payload = [payload] unless payload.is_a?(Array)

        payload.each_with_object([]) do |item, pl|
          pl << payload_abridge(item)
        end
      end

      def payload_abridge(payload)
        data          = RecursiveOpenStruct.new(payload).to_h
        data_override = RecursiveOpenStruct.new(payload_override).to_h

        data.deep_merge(data_override)
      end

      def payload_override
        {}
      end

      def retire_object(obj)
        retire_array = obj.is_a?(Array) ? obj : obj.to_s.split(",").map(&:to_i)

        { ids: retire_array }
      end
    end
  end
end
