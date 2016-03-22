module Shipwire
  class Api
    def request(method, path, body: {}, params: {})
      Request.send(method: method, path: path, body: body, params: params)
    end
  end
end
