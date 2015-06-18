module Shipwire
  class Api
    def request(method, path, options = {})
      response = Response.new

      begin
        response.response = Request.new.
          method(method).
          path(path).
          payload(options[:payload] || {}).
          params(options[:params] || {}).
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
