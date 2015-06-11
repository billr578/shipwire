module Shipwire
  module Products
    class VirtualKit < Base
      protected

      def payload_override
        { classification: "virtualKit" }
      end
    end
  end
end
