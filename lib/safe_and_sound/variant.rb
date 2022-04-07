# frozen_string_literal: true

module SafeAndSound
  class MissingConstructorArg < StandardError; end
  class UnknownConstructorArg < StandardError; end
  class WrgonConstructorArgType < StandardError; end

  ##
  # base class for a variant of the newly defined types
  class Variant
    def initialize(**args)
      missing_fields = self.class.fields.keys
      args.each do |field_name, value|
        initialize_field(field_name, value)
        missing_fields.delete(field_name)
      end

      return if missing_fields.empty?

      raise MissingConstructorArg, "Not all constructor arguments were supplied: #{missing_fields}"
    end

    class << self
      attr_accessor :fields

      def build(variant_name, fields, parent_type)
        new_variant = Class.new(Variant)
        new_variant.fields = fields
        fields.each { |field, _| new_variant.attr_reader field }
        parent_type.const_set(variant_name.to_s, new_variant)
        new_variant
      end
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
end
