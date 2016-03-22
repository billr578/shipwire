module Shipwire
  module Utility
    def self.camel_case(options)
      ParamConverter.new(options).to_h
    end

    def self.split_to_integers(str, separator = ",")
      str.to_s.split(separator).map(&:to_i)
    end

    def self.camelize(term, first_letter = :upper)
      terms = term.split('_')

      case first_letter
      when :upper
        terms.map(&:capitalize!).join
      when :lower
        ([terms.first] + terms.drop(1).map(&:capitalize!)).join
      end
    end
  end
end
