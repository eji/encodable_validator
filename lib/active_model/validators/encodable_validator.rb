require 'active_model/validations'

module ActiveModel
  module Validations
    class EncodableValidator < ActiveModel::EachValidator
      def check_validity!
        values = options[:encodings]
        unless values.respond_to?(:all?) and values.all? {|v| v.class <= Encoding} 
          raise ArgumentError, ":encodings must be a array of Encodings"
        end
      end

      def validate_each(record, attr_name, value)
        return if options[:allow_nil] && value.nil?

        unless value.respond_to?(:encode)
          record.errors.add(attr_name, :not_a_encodable_object , options)
          return
        end

        src_enc = value.encoding
        last_enc = nil
        begin
          options[:encodings].each do |enc|
            last_enc = enc
            value.encode(enc, src_enc)
          end
        rescue Encoding::UndefinedConversionError
          record.errors.add(attr_name, :can_not_be_encoded, options.merge(
            :value => value,
            :encoding => last_enc
          ))
          return
        rescue Encoding::InvalidByteSequenceError
          record.errors.add(attr_name, :included_invalid_byte_sequences, options)
          return
        end
      end
    end

    module HelperMethods
      # Usage:
      #   class Person < ActiveRecord::Base
      #     validates_encodable_of :name, :encodings => [Encoding::ISO_2022_JP, Encoding::EUC_JP]
      #   end
      #
      # Configuration options:
      # * <tt>:encodings</tt> - check that a text can be encoded to specified encodings.
      def validates_encodable_of(*attr_names)
        validates_with EncodableValidator, _merge_attributes(attr_names)
      end
    end
  end
end
