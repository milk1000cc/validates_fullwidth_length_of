require 'active_record'
require File.dirname(__FILE__) + '/validates_fullwidth_length_of/unicodedata'
require File.dirname(__FILE__) + '/validates_fullwidth_length_of/version'

module ActiveModel::Validations::ClassMethods
  def validates_fullwidth_length_of(*attrs)
    options = attrs.extract_options!
    options.merge!(:tokenizer => lambda { |str| ValidatesFullwidthLengthOf::Tokenizer.new(str) })
    validates_length_of *attrs.push(options)
  end

  alias_method :validates_fullwidth_size_of, :validates_fullwidth_length_of
end

module ValidatesFullwidthLengthOf
  class Tokenizer < Struct.new(:value)
    def size
      value.split(//).inject(0.0) { |size, c| size + ('WFA'.include?(Unicodedata.east_asian_width(c)) ? 1 : 0.5) }
    end
  end
end
