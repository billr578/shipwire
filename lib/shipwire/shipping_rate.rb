require 'nokogiri'

module Shipwire
  class ShippingRate < Shipwire::ServiceRequest
    attr_reader :shipping_quotes

    API_PATH = 'RateServices.php'

    def initialize(params={})
      super

      @shipping_quotes = []

      @api_path = ShippingRate::API_PATH

      @address1 = params[:address][:address1] || ''
      @address2 = params[:address][:address2] || ''
      @city = params[:address][:city] || ''
      @state = params[:address][:state] || ''
      @country = params[:address][:country] || ''
      @zip = params[:address][:zip] || ''

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
            code = quote.xpath('CarrierCode').text
            cost = quote.xpath('Cost').text

            @shipping_quotes << { service: service,
              carrier_code: code,
              cost: cost }
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
          xml.EmailAddress Shipwire.username
          xml.Password Shipwire.password

          xml.Order {
            xml.Warehouse '00'

            xml.AddressInfo(type: 'ship') {
              xml.Address1 @address1
              xml.Address2 @address2
              xml.City @city
              xml.State @state
              xml.Country @country
              xml.Zip @zip
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
