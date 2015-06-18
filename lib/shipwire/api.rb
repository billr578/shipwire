module Shipwire
  class Api
    def request(method, path, payload = {}, params = {})
      response = Response.new

      begin
        response.response = Request.new.method(method).
          path(path).
          payload(payload).
          params(params).
          send
      rescue Faraday::ConnectionFailed
        response.api_errors << 'Unable to connect to Shipwire'
      rescue Faraday::TimeoutError
        response.api_errors << 'Shipwire connection timeout'
      end

      response
    end
  end
end
