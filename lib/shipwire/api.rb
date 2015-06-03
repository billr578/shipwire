require 'json'

module Shipwire
  class Api
    API_VERSION = 3

    attr_reader :response,
                :api_errors,
                :shipwire_errors

    def initialize
      @response        = nil
      @api_errors      = []
      @shipwire_errors = []
    end

    def request(method, path, payload = {}, params = {})
      begin
        request = connection.send(method, request_path(path)) do |r|
          r.params  = request_params(params)
          r.options = request_options
          r.headers = request_headers
          r.body    = payload.to_json unless payload.empty?
        end

        @response = parse_response(request)
      rescue Faraday::ConnectionFailed
        @api_errors << 'Unable to connect to Shipwire'
      rescue Faraday::TimeoutError
        @api_errors << 'Shipwire connection timeout'
      end

      self
    end

    def ok?
      errors.empty?
    end

    def errors
      api_errors + shipwire_errors
    end

    def errors?
      api_errors? || shipwire_errors?
    end

    def api_errors?
      !api_errors.empty?
    end

    def shipwire_errors?
      !shipwire_errors.empty?
    end

    private

    def connection
      Faraday.new(url: request_base) do |c|
        c.use Faraday::Request::BasicAuthentication, auth_user, auth_pass
        c.use Faraday::Response::Logger if Rails.env.development?

        c.request(:url_encoded)
        c.adapter(Faraday.default_adapter)
      end
    end

    def request_base
      Shipwire.configuration.endpoint.chomp("/")
    end

    def request_path(path)
      "/api/v#{API_VERSION}/#{path}"
    end

    # The Shipwire API uses PHP. The PHP community uses camel case. The Ruby
    # community uses snake case. Allow snake case to be passed in, but send it
    # as camel case.
    def request_params(params)
      # TODO: Convert params to camelCase to make Shipwire's PHP API happy
      params
    end

    def request_options
      {
        open_timeout: Shipwire.configuration.open_timeout,
        timeout:      Shipwire.configuration.timeout
      }
    end

    def request_headers
      { 'Content-Type' => 'application/json' }
    end

    def auth_user
      Shipwire.configuration.username
    end

    def auth_pass
      Shipwire.configuration.password
    end

    def parse_response(response)
      struct = DeepOpenStruct.new(JSON.parse(response.body))

      @shipwire_errors << struct.message if /^[45]+/.match(struct.status.to_s)

      struct
    end
  end
end
