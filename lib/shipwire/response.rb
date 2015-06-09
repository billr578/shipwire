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

    def populate_warnings(payload)
      if payload.warnings
        payload.warnings.each { |item| shipwire_warnings << item.message }
      end
    end

    def populate_errors(payload)
      populate_status_errors(payload)

      populate_response_errors(payload)
    end

    # Errors because of a 40x or 50x error
    def populate_status_errors(payload)
      if /^[45]+/.match(payload.status.to_s)
        shipwire_errors << payload.message
      end
    end

    # Errors specified in Shipwire response body
    def populate_response_errors(payload)
      if payload.errors && payload.errors.is_a?(Array)
        payload.errors.each do |item|
          message = item.is_a?(RecursiveOpenStruct) ? item.message : item

          shipwire_errors << message
        end
      end
    end
  end
end
