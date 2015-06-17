module Shipwire
  module Utility
    def self.camel_case(options)
      ParamConverter.new(options).to_h
    end

    def self.split_to_integers(str, separator = ",")
      str.to_s.split(separator).map(&:to_i)
    end
  end
end
