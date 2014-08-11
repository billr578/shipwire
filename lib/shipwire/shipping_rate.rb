require 'nokogiri'

module Shipwire
  class ShippingRate < Shipwire::ServiceRequest
    attr_reader :shipping_quotes

    API_PATH = 'RateServices.php'

    def initialize(params={})
      super

      @shipping_quotes = []
      @api_path = ShippingRate::API_PATH
      @address = params[:address]
      @items = params[:items] || []   # [ { code: '123456', quantity: 1 } ]

      self.build_payload
    end

    def parse_response
      if @response != nil
        xml = Nokogiri::XML(@response.body)
        @rate_response = xml.xpath('//RateResponse')
      end

      if @rate_response != nil
        if is_ok?(@rate_response)
          quotes = @rate_response.xpath('//Quote')
          quotes.each do |quote|
            service = quote.xpath('Service').text
            carrier_code = quote.xpath('CarrierCode').text
            cost = quote.xpath('Cost').text

            @shipping_quotes << {
              service: service,
              carrier_code: carrier_code,
              code: quote.attributes['method'].value,
              cost: cost
            }
          end
        else
          @errors << 'Unsuccessful request'
        end
      end

      if @shipping_quotes.count <= 0
        @errors << 'Unable to get shipping rates from Shipwire'
      end
    end

    protected
    def build_payload
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.RateRequest {
          xml.Username Shipwire.username
          xml.Password Shipwire.password

          xml.Order {
            xml.Warehouse '00'

            xml.AddressInfo(type: 'ship') {
              xml.Address1 @address[:address1]
              xml.Address2 @address[:address2]
              xml.City @address[:city]
              xml.State @address[:state]
              xml.Country @address[:country]
              xml.Zip @address[:zip]
            }

            count = 0
            @items.each do |item|
              xml.Item(num: count) {
                xml.Code item[:code]
                xml.Quantity item[:quantity]
              }

              count += 1
            end
          }
        }
      end

      self.payload = builder.to_xml
    end
  end
end
