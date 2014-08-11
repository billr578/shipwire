require 'nokogiri'

module Shipwire
  class Inventory < Shipwire::ServiceRequest
    attr_reader :inventory_responses

    API_PATH = 'InventoryServices.php'

    def initialize(params={})
      super

      @inventory_responses = []
      @api_path = Inventory::API_PATH

      @product_code = params[:product_code] || nil

      self.build_payload
    end

    def parse_response
      if @response != nil
        xml = Nokogiri::XML(@response.body)
        @inventory_response = xml.xpath('//InventoryUpdateResponse')
      end

      if @inventory_response != nil
        if is_ok?(@inventory_response)

          products = @inventory_response.xpath('//Product')

          products.each do |product|
            code = product.attributes['code'].value
            quantity = product.attributes['quantity'].value
            good = product.attributes['good'].value
            pending = product.attributes['pending'].value
            backordered = product.attributes['backordered'].value

            @inventory_responses << {
              code: code,
              inventory: {
                quantity: quantity,
                good: good,
                pending: pending,
                backordered: backordered
              }
            }
          end
        end
      end
    end

    protected
    def build_payload
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.InventoryUpdate {
          xml.Username Shipwire.username
          xml.Password Shipwire.password
          xml.Server Shipwire.server

          if @product_code != nil
            xml.ProductCode @product_code
          end
        }
      end

      self.payload = builder.to_xml
    end

  end
end
