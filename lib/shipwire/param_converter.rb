module Shipwire
  class ParamConverter
    attr_accessor :params

    def initialize(params)
      if params.is_a?(Array)
        @params = params.each_with_object([]) do |item, hsh|
          hsh << recursively_struct(item)
        end
      else
        @params = recursively_struct(params)
      end
    end

    def to_h
      with_object(params)
    end

    private

    def recursively_struct(item)
      RecursiveOpenStruct.new(item, recurse_over_arrays: true).to_h
    end

    def with_object(hash)
      hash.each_with_object({}) do |(k, value), h|
        key = k.to_s.camelize(:lower).to_sym

        h[key] = value.is_a?(Hash) ? with_object(value) : value
      end
    end
  end
end
