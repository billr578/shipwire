require 'nokogiri'

module Shipwire
  class Tracking < Shipwire::ServiceRequest
    attr_reader :order_responses

    API_PATH = 'TrackingServices.php'

    def initialize(params={})
      super

      @order_responses = []
      @api_path = Tracking::API_PATH

      @bookmark = params[:bookmark]
      if @bookmark == '1'
        raise Shipwire::TrackingError.new('Ability to return all orders has been deprecated')
      end

      @order_number = params[:order_number]
      @shipwire_id = params[:shipwire_id]

      # Default to since last bookmark
      if (@bookmark == nil || @bookmark == '') &&
        (@order_number == nil || @order_number == '') &&
        (@shipwire_id == nil || @shipwire_id == '')
        @bookmark = '2'
      end

      self.build_payload
    end

    def parse_response
      if @response != nil
        xml = Nokogiri::XML(@response.body)
        tracking_update_response = xml.xpath('//TrackingUpdateResponse')

        if tracking_update_response != nil
          if is_ok?(tracking_update_response)

            orders = tracking_update_response.xpath('//Order')

            orders.each do |order|
              tracking_numbers = order.xpath('TrackingNumber')

              tracking_data = []
              tracking_numbers.each do |number|
                tracking_data << {
                  carrier: number.attributes['carrier'].value,
                  tracking_link: number.attributes['href'].value,
                  tracking_number: number.text
                }
              end

              @order_responses << {
                order_number: order.attributes['id'].value,
                shipped: order.attributes['shipped'].value,
                ship_date: (order.attributes['shipDate'] != nil ? order.attributes['shipDate'].value : ''),
                delivered: (order.attributes['delivered'] != nil ? order.attributes['delivered'].value : ''),
                expected_delivery_date: (order.attributes['expectedDeliveryDate'] != nil ? order.attributes['expectedDeliveryDate'].value : ''),
                fulfillment_data: {
                  handling: (order.attributes['handling'] != nil ? order.attributes['handling'].value : '0'),
                  shipping: (order.attributes['shipping'] != nil ? order.attributes['shipping'].value : '0'),
                  packaging: (order.attributes['packaging'] != nil ? order.attributes['packaging'].value : '0')
                },
                tracking_numbers: tracking_data
              }
            end
          else
            @errors << 'Unsuccessful request'
          end
        else
          @errors << 'Unsuccessful request'
        end
      else
        @errors << 'Unsuccessful request'
      end
    end

    protected
    def build_payload
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.TrackingUpdate {
          xml.Username Shipwire.username
          xml.Password Shipwire.password
          xml.Server Shipwire.server

          if @bookmark != '' && @bookmark != nil
            xml.Bookmark @bookmark
          elsif @shipwire_id != '' && @shipwire_id != nil
            xml.ShipwireId @shipwire_id
          else
            xml.OrderNo @order_number
          end
        }
      end

      self.payload = builder.to_xml
    end
  end
end
