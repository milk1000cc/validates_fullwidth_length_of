require 'unicodedata'

module ActiveRecord
  module Validations
    module ClassMethods
      def validates_fullwidth_length_of(*attrs)
        options = DEFAULT_VALIDATION_OPTIONS.dup
        options.update(attrs.extract_options!.symbolize_keys)

        range_options = ALL_RANGE_OPTIONS & options.keys
        case range_options.size
          when 0
            raise ArgumentError, 'Range unspecified.  Specify the :within, :maximum, :minimum, or :is option.'
          when 1
            # Valid number of options; do nothing.
          else
            raise ArgumentError, 'Too many range options specified.  Choose only one.'
        end

        option = range_options.first
        option_value = options[range_options.first]
        key = {:is => :wrong_length, :minimum => :too_short, :maximum => :too_long}[option]
        custom_message = options[:message] || options[key]

        case option
          when :within, :in
            raise ArgumentError, ":#{option} must be a Range" unless option_value.is_a?(Range)

            validates_each(attrs, options) do |record, attr, value|
              if value.nil? or fullwidth_size(value) < option_value.begin
                record.errors.add(attr, :too_short, :default => custom_message || options[:too_short], :count => option_value.begin)
              elsif fullwidth_size(value) > option_value.end
                record.errors.add(attr, :too_long, :default => custom_message || options[:too_long], :count => option_value.end)
              end
            end
          when :is, :minimum, :maximum
            raise ArgumentError, ":#{option} must be a nonnegative Number" unless option_value.is_a?(Numeric) and option_value >= 0

            # Declare different validations per option.
            validity_checks = { :is => "==", :minimum => ">=", :maximum => "<=" }

            validates_each(attrs, options) do |record, attr, value|
              unless !value.nil? and fullwidth_size(value).method(validity_checks[option])[option_value]
                record.errors.add(attr, key, :default => custom_message, :count => option_value)
              end
            end
        end
      end

      alias_method :validates_fullwidth_size_of, :validates_fullwidth_length_of

      private
      def fullwidth_size(value)
        size = 0.0
        value.split(//).each { |c| size += ('WFA'.include?(Unicodedata.east_asian_width(c)) ? 1 : 0.5) }
        size
      end
    end
  end
end
