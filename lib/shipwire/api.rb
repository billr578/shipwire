module Shipwire
  class Api
    def request(method, path, body: {}, params: {})
      Request.send(method: method, path: full_path(path), body: body, params: params)
    end

    private

    def api_version
      'v3'
    end

    def full_path(path)
      "#{api_version}/#{path}"
    end
  end
end
