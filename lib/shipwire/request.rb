module Shipwire
  class Request
    def self.send(**args)
      new(**args).send
    end

    attr_reader :method, :path, :params, :body

    def initialize(method: :get, path: '', params: {}, body: {})
      @method = method
      @path = path
      @params = params
      @body = body

      @connection = build_connection
    end

    def send
      Response.new(underlying_response: make_request)
    rescue Faraday::ConnectionFailed
      Response.new(error_summary: 'Unable to connect to Shipwire')
    rescue Faraday::TimeoutError
      Response.new(error_summary: 'Shipwire connection timeout')
    end

    private

    def build_connection
      Faraday.new(url: base_url) do |connection|
        connection.request(:basic_auth, username, password)
        connection.request(:json)
        connection.request(:url_encoded)

        if Shipwire.configuration.logger
          connection.response(:logger)
        end

        connection.adapter(Faraday.default_adapter)
      end
    end

    def make_request
      @connection.public_send(@method, full_path) do |request|
        request.params = params unless params.empty?
        request.options.open_timeout = Shipwire.configuration.open_timeout
        request.options.timeout = Shipwire.configuration.timeout
        request.body = body unless body.empty?
      end
    end

    def base_url
      Shipwire.configuration.endpoint.chomp("/")
    end

    def full_path
      "/api/#{@path}"
    end

    def params
      Utility.camel_case(@params)
    end

    def username
      Shipwire.configuration.username
    end

    def password
      Shipwire.configuration.password
    end
  end
end
