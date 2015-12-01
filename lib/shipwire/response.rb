require 'json'

module Shipwire
  class Response
    attr_reader :error_summary, :validation_errors, :warnings, :body

    def initialize(underlying_response: nil, error_summary: nil)
      @error_summary = error_summary

      @validation_errors = []
      @warnings = []

      if underlying_response
        load_response(underlying_response)
      end
    end

    def ok?
      !has_error_summary? && !has_validation_errors?
    end

    def has_error_summary?
      !error_summary.nil?
    end

    def has_validation_errors?
      !validation_errors.empty?
    end

    def has_warnings?
      !warnings.empty?
    end

    private

    def load_response(response)
      @body = JSON.parse(response.body)
      @warnings = parse_warnings_from(body)
      @error_summary = parse_error_summary_from(body)
      @validation_errors = parse_validation_errors_from(body)
    end

    # Errors because of a 40x or 50x error
    def parse_error_summary_from(body)
      if (400..599).include?(body['status']) && body.key?('message')
        body['message']
      else
        nil
      end
    end

    # Errors specified in Shipwire response body
    def parse_validation_errors_from(body)
      body.fetch('errors', {})
    end

    def parse_warnings_from(body)
      body.fetch('warnings', []).map do |warning|
        warning.fetch('message')
      end
    end
  end
end
