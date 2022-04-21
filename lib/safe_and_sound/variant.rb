# frozen_string_literal: true

module SafeAndSound
  class MissingConstructorArg < StandardError; end
  class UnknownConstructorArg < StandardError; end
  class WrgonConstructorArgType < StandardError; end

  ##
  # base class for a variant of the newly defined types
  module Variant
    ##
    # Mixin used in Variant types to initialize fields from
    # constructor arguments.
    module Initializer
      def initialize_fields(**args)
        missing_fields = self.class.fields.keys
        args.each do |field_name, value|
          initialize_field(field_name, value)
          missing_fields.delete(field_name)
        end

        return if missing_fields.empty?

        raise MissingConstructorArg, "Not all constructor arguments were supplied: #{missing_fields}"
      end

      def to_s
        "<#{self.class.superclass.name}:#{self.class.variant_name} ..."
      end

      def variant_type?
        true
      end

      private

      def initialize_field(field_name, value)
        field_type = self.class.fields[field_name]
        if field_type.nil?
          raise UnknownConstructorArg,
                "#{self.class.name} does not have a constructor argument #{field_name}"
        end

        if field_type_matches?(field_type, field_name, value)
          instance_variable_set("@#{field_name}", value)
        else
          instance_variable_set("@#{field_name}", try_to_initialize_from_hash(field_type, field_name, value))
        end
      end

      def field_type_matches?(field_type, field_name, value)
        return value.is_a?(field_type) unless field_type.is_a?(Array)

        expected_item_type = field_type.first
        unless value.is_a?(Array)
          raise WrgonConstructorArgType,
                "#{field_name} must be an Array of #{expected_item_type} but was #{value.class}"
        end

        mismatched_types =
          value.map do |item|
            if item.is_a?(expected_item_type)
              nil
            else
              item.class
            end
          end.compact
        return true if mismatched_types.empty?

        raise WrgonConstructorArgType,
              "Expected #{field_name} to only contain #{expected_item_type}, " \
              "but also found #{mismatched_types.map(&:name).join(',')}"
      end

      def try_to_initialize_from_hash(field_type, field_name, value)
        unless field_type.superclass == Type && value.is_a?(Hash)
          raise WrgonConstructorArgType,
                "#{field_name} must be of type #{field_type} but was #{value.class.name}"
        end
        field_type.from_hash(value)
      end
    end

    def self.build(variant_name, fields, parent_type)
      new_variant = create_variant_type(parent_type)
      new_variant.fields = fields
      new_variant.variant_name = variant_name
      fields.each { |field, _| new_variant.attr_reader field }
      parent_type.const_set(variant_name.to_s, new_variant)
      parent_type.define_singleton_method(variant_name) do |**args|
        new_variant.new(**args)
      end
      new_variant
    end

    def self.create_variant_type(parent_type)
      Class.new(parent_type) do
        include(Initializer)
        include(Functions)
        include(ToJson)

        class << self
          attr_accessor :fields, :variant_name
        end

        def initialize(**args)
          initialize_fields(**args)
        end
      end
    end
  end
end
