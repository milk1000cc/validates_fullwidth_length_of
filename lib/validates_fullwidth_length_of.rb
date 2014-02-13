require File.dirname(__FILE__) + '/validates_fullwidth_length_of/unicodedata'
require File.dirname(__FILE__) + '/validates_fullwidth_length_of/version'

module ActiveModel
  module Validations
    class FullwidthLengthValidator < LengthValidator
      DEFAULT_TOKENIZER = lambda { |str| ValidatesFullwidthLengthOf::Tokenizer.new(str) }

      private

      def tokenize(value)
        if value.kind_of?(String)
          (options[:tokenizer] || DEFAULT_TOKENIZER).call(value)
        end || value
      end
    end

    module HelperMethods
      def validates_fullwidth_length_of(*attr_names)
        validates_with FullwidthLengthValidator, _merge_attributes(attr_names)
      end

      alias_method :validates_fullwidth_size_of, :validates_fullwidth_length_of
    end
  end
end

module ValidatesFullwidthLengthOf
  class Tokenizer < Struct.new(:value)
    def size
      value.split(//).inject(0.0) { |size, c| size + ('WFA'.include?(Unicodedata.east_asian_width(c)) ? 1 : 0.5) }
    end
    alias :length :size
  end
end
