module Shipwire
  class Request
    API_VERSION = 3

    attr_reader :method,
                :path,
                :params,
                :payload

    def initialize
      @method  = :get
      @path    = ''
      @params  = {}
      @payload = {}
    end

    def method(meth)
      @method = meth

      self
    end

    def path(loc)
      @path = loc

      self
    end

    def params(par)
      @params = par

      self
    end

    def payload(payl)
      @payload = payl

      self
    end

    def send
      connection.send(@method, request_path) do |req|
        req.params = request_params unless @params.empty?
        req.options.open_timeout = Shipwire.configuration.open_timeout
        req.options.timeout = Shipwire.configuration.timeout
        req.headers = request_headers
        req.body = request_body unless @payload.empty?
      end
    end

    private

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

    def request_path
      "/api/v#{API_VERSION}/#{@path}"
    end

    def request_params
      Utility.camel_case(@params)
    end

    def request_headers
      { 'Content-Type' => 'application/json' }
    end

    def request_body
      Utility.camel_case(@payload).to_json
    end

    def auth_user
      Shipwire.configuration.username
    end

    def auth_pass
      Shipwire.configuration.password
    end
  end
end
