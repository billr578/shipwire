module Shipwire
  module Products
    class Kit < Base
      protected

      def payload_override
        { classification: "kit" }
      end
    end
  end
end
