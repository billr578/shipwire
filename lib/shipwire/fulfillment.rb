require 'nokogiri'

module Shipwire
  class Fulfillment < Shipwire::ServiceRequest
    attr_reader :order_responses

    API_PATH = 'FulfillmentServices.php'

    def initialize(params={})
      super

      @order_responses = []
      @api_path = Fulfillment::API_PATH
      @orders = params[:orders]

      self.build_payload
    end

    def parse_response
      if @response != nil
        xml = Nokogiri::XML(@response.body)
        @fulfillment_response = xml.xpath('//SubmitOrderResponse')
      end

      if @fulfillment_response != nil
        if is_ok?(@fulfillment_response)
          orders = @fulfillment_response.xpath('//Order')

          orders.each do |order|
            order_number = order.attributes['number'].value
            fulfillment_id = order.attributes['id'].value
            status = order.attributes['status'].value

            shipping = order.xpath('Shipping')

            shipping_cost = shipping.xpath('Cost').text
            shipping_service = shipping.xpath('Service').text

            @order_responses << {
              order_number: order_number,
              fulfillment_id: fulfillment_id,
              status: status,
              shipping: {
                service: shipping_service,
                cost: shipping_cost
              }
            }
          end
        else
          @errors << 'Unsuccessful request'
        end
      end
    end

    protected
    def build_payload
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.OrderList {
          xml.Username Shipwire.username
          xml.Password Shipwire.password
          xml.Server Shipwire.server

          @orders.each do |order|
            xml.Order(id: order[:order_number]) {
              xml.Warehouse '00'

              xml.AddressInfo(type: 'ship') {
                xml.Name {
                  xml.Full "#{order[:address][:first_name]} #{order[:address][:last_name]}"
                }
                xml.Address1 order[:address][:address1]
                xml.Address2 order[:address][:address2]
                xml.City order[:address][:city]
                xml.State order[:address][:state]
                xml.Country order[:address][:country]
                xml.Zip order[:address][:zip]
                xml.Phone order[:address][:phone]
                xml.Email order[:email]
              }

              xml.Shipping order[:shipping]

              count = 0
              order[:items].each do |item|
                xml.Item(num: count) {
                  xml.Code item[:code]
                  xml.Quantity item[:quantity]
                }

                count += 1
              end
            }
          end
        }
      end

      self.payload = builder.to_xml
    end
  end
end
