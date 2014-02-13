require File.dirname(__FILE__) + '/validates_fullwidth_length_of/unicodedata'
require File.dirname(__FILE__) + '/validates_fullwidth_length_of/version'

module ActiveModel
  module Validations
    class FullwidthLengthValidator < LengthValidator
      MESSAGES = { :is => :fullwidth_wrong_length, :minimum => :fullwidth_too_short, :maximum => :fullwidth_too_long }.freeze

      DEFAULT_TOKENIZER = lambda { |str| ValidatesFullwidthLengthOf::Tokenizer.new(str) }

      def validate_each(record, attribute, value)
        value = tokenize(value)
        value_length = value.respond_to?(:length) ? value.length : value.to_s.length
        errors_options = options.except(*RESERVED_OPTIONS)

        CHECKS.each do |key, validity_check|
          next unless check_value = options[key]

          if !value.nil? || skip_nil_check?(key)
            next if value_length.send(validity_check, check_value)
          end

          errors_options[:count] = check_value

          default_message = options[MESSAGES[key]]
          errors_options[:message] ||= default_message if default_message

          record.errors.add(attribute, MESSAGES[key], errors_options)
        end
      end

      private

      def tokenize(value)
        if value.kind_of?(String)
          (options[:tokenizer] || DEFAULT_TOKENIZER).call(value)
        end || value
      end

      def skip_nil_check?(key)
        key == :maximum && options[:allow_nil].nil? && options[:allow_blank].nil?
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
