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

        unless value.is_a?(field_type)
          raise WrgonConstructorArgType,
                "#{field_name} must be of type #{field_type} but was #{value.class.name}"
        end
        instance_variable_set("@#{field_name}", value)
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
