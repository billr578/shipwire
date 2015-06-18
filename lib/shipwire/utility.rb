module Shipwire
  module Utility
    def self.camel_case(options)
      ParamConverter.new(options).to_h
    end

    def self.split_to_integers(str, separator = ",")
      str.to_s.split(separator).map(&:to_i)
    end

    def self.camelize(term)
      string = term.to_s.sub(/^[a-z\d]*/) { |match| match.capitalize }

      camelizer(string)
    end

    def self.camelize_lower(term)
      string = term.to_s.sub(/^(?:(?=a)b(?=\b|[A-Z_])|\w)/) { |match| match.downcase }

      camelizer(string)
    end

    protected

    def self.camelizer(string)
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }

      string
    end
  end
end
