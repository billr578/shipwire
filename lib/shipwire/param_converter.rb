module Shipwire
  class ParamConverter
    attr_accessor :params

    def initialize(params)
      @params = RecursiveOpenStruct.new(params).to_h
    end

    def to_h
      with_object(params)
    end

    private

    def with_object(hash)
      hash.each_with_object({}) do |(k, value), h|
        key = k.to_s.camelize(:lower).to_sym

        h[key] = value.is_a?(Hash) ? with_object(value) : value
      end
    end
  end
end
