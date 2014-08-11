require 'faraday'

module Shipwire
  class ServiceRequest
    attr_accessor :payload, :api_path
    attr_reader :response, :errors

    def initialize(params={})
      @errors = []
    end

    def send
      begin
        connection = Faraday.new(url: Shipwire.endpoint) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end

        @response = connection.post @api_path, @payload
      rescue Faraday::ConnectionFailed
        @errors << 'Unable to connect to Shipwire'
      rescue
        @errors << 'Unknown error'
      end
    end

    def is_ok?(element)
      status = element.xpath('//Status').text

      return status == 'OK' || status == "0"
    end

    def parse_response
      raise 'Override this'
    end

    protected
    def build_payload
      raise 'Override this'
    end
  end
end
