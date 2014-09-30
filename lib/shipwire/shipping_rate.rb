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
            cost = quote.xpath('Cost').text.to_f
            subtotals = quote.xpath('Subtotals')
            delivery_estimate = quote.xpath('DeliveryEstimate')

            freight = 0.0
            insurance = 0.0
            packaging = 0.0
            handling = 0.0

            subtotals.xpath('Subtotal').each do |subtotal|
              case subtotal.attributes['type'].text
              when 'Freight'
                freight = subtotal.xpath('Cost').text.to_f
              when 'Insurance'
                insurance = subtotal.xpath('Cost').text.to_f
              when 'Packaging'
                packaging = subtotal.xpath('Cost').text.to_f
              when 'Handling'
                handling = subtotal.xpath('Cost').text.to_f
              end
            end

            if delivery_estimate != nil
              minimum = delivery_estimate.xpath('Minimum')
              maximum = delivery_estimate.xpath('Maximum')
            end

            @shipping_quotes << {
              service: service,
              carrier_code: carrier_code,
              code: quote.attributes['method'].value,
              cost: cost,
              subtotals: {
                freight: freight,
                insurance: insurance,
                packaging: packaging,
                handling: handling
              },
              delivery_estimate: {
                minimum: minimum == nil ? '' : minimum.text,
                maximum: maximum == nil ? '' : maximum.text
              }
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
