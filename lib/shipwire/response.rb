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
      json = JSON.parse(payload.body)

      @response = RecursiveOpenStruct.new(json, recurse_over_arrays: true)

      populate_errors
      populate_warnings
    end

    private

    def populate_warnings
      [*response.warnings].each { |item| shipwire_warnings << item.message }
    end

    def populate_errors
      populate_status_errors

      populate_response_errors
    end

    # Errors because of a 40x or 50x error
    def populate_status_errors
      if /^[45]+/.match(response.status.to_s)
        shipwire_errors << response.message
      end
    end

    # Errors specified in Shipwire response body
    def populate_response_errors
      [*response.errors].each do |item|
        message = item.is_a?(RecursiveOpenStruct) ? item.message : item

        shipwire_errors << message
      end
    end
  end
end
