require 'unicodedata'

module ActiveRecord
  module Validations
    module ClassMethods
      def validates_fullwidth_length_of(*attrs)
        options = attrs.extract_options!
        options.merge!(:tokenizer => lambda { |str| FullwidthTokenizer.new(str) })
        validates_length_of *attrs.push(options)
      end

      alias_method :validates_fullwidth_size_of, :validates_fullwidth_length_of
    end
  end
end

class FullwidthTokenizer < Struct.new(:value)
  def size
    value.split(//).inject(0.0) { |size, c| size + ('WFA'.include?(Unicodedata.east_asian_width(c)) ? 1 : 0.5) }
  end
end
