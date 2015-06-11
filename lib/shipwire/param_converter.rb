module Shipwire
  class ParamConverter
    attr_reader :params

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
      if params.is_a?(Array)
        params.each_with_object([]) do |item, hsh|
          hsh << with_object(item)
        end
      else
        with_object(params)
      end
    end

    private

    def recursively_struct(item)
      RecursiveOpenStruct.new(item, recurse_over_arrays: true).to_h
    end

    def with_object(item)
      item.each_with_object({}) do |(original_key, value), hsh|
        key = original_key.to_s.camelize(:lower).to_sym

        hsh[key] = value.is_a?(Hash) ? with_object(value) : value
      end
    end
  end
end
