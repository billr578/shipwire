module Shipwire
  class Api
    API_VERSION = 3

    def request(method, path, payload = {}, params = {})
      response = Response.new

      begin
        response.response = send_request(method, path, payload, params)
      rescue Faraday::ConnectionFailed
        response.api_errors << 'Unable to connect to Shipwire'
      rescue Faraday::TimeoutError
        response.api_errors << 'Shipwire connection timeout'
      end

      response
    end

    private

    def send_request(method, path, payload = {}, params = {})
      connection.send(method, request_path(path)) do |r|
        r.params  = camel_case(params) unless params.empty?
        r.options = request_options
        r.headers = request_headers
        r.body    = camel_case(payload).to_json unless payload.empty?
      end
    end

    def connection
      Faraday.new(url: request_base) do |c|
        c.use Faraday::Request::BasicAuthentication, auth_user, auth_pass
        c.use Faraday::Response::Logger unless Rails.env.production?

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

    def camel_case(options)
      ParamConverter.new(options).to_h
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
  end
end
