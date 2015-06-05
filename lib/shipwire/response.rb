require 'json'

module Shipwire
  class Response
    attr_accessor :shipwire_errors,
                  :shipwire_warnings,
                  :api_errors,
                  :response

    def initialize
      @shipwire_errors   = []
      @shipwire_warnings = []
      @api_errors        = []
      @response          = nil
    end

    def ok?
      errors.empty?
    end

    def errors?
      api_errors? || shipwire_errors?
    end

    def errors
      api_errors + shipwire_errors
    end

    def api_errors?
      !api_errors.empty?
    end

    def shipwire_errors?
      !shipwire_errors.empty?
    end

    def warnings?
      !shipwire_warnings.empty?
    end

    def response=(payload)
      @response = parse_response(payload)
    end

    private

    def parse_response(payload)
      json   = JSON.parse(payload.body)
      struct = RecursiveOpenStruct.new(json, recurse_over_arrays: true)

      populate_errors(struct)
      populate_warnings(struct)

      struct
    end

    def populate_errors(payload)
      # Errors because of a 40x or 50x error
      if /^[45]+/.match(payload.status.to_s)
        shipwire_errors << payload.message
      end

      # Errors specified in Shipwire response body
      if payload.errors
        payload.errors.each do |item|
          message = item.is_a?(Array) ? item.message : item

          shipwire_errors << message
        end
      end
    end

    def populate_warnings(payload)
      if payload.warnings
        payload.warnings.each { |item| shipwire_warnings << item.message }
      end
    end
  end
end
