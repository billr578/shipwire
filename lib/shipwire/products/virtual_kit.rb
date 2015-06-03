module Shipwire
  module Products
    class VirtualKit < Base
      private

      def payload_override
        { classification: "virtualKit" }
      end
    end
  end
end
