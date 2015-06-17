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
      connection.send(method, request_path(path)) do |req|
        req.params  = Utility.camel_case(params) unless params.empty?
        req.options = request_options
        req.headers = request_headers
        req.body    = Utility.camel_case(payload).to_json unless payload.empty?
      end
    end

    def connection
      Faraday.new(url: request_base) do |conn|
        conn.use Faraday::Request::BasicAuthentication, auth_user, auth_pass

        conn.adapter(Faraday.default_adapter)
        conn.response(:logger) if Shipwire.configuration.logger
        conn.request(:url_encoded)
      end
    end

    def request_base
      Shipwire.configuration.endpoint.chomp("/")
    end

    def request_path(path)
      "/api/v#{API_VERSION}/#{path}"
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
