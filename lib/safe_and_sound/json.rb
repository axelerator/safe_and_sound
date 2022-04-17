# frozen_string_literal: true
require 'json'

module SafeAndSound
  module ToJson
    def as_json
      hash = { 'type' => self.class.variant_name.to_s }
      self.class.fields.each do |field_name, _|
        value = send(field_name)
        hash[field_name.to_s] = 
          if value.respond_to?(:as_json)
            value.as_json
          else
            value
          end
      end
      hash
    end

    def to_json(*_args)
      as_json.to_json
    end
  end

  module FromJson
    def from_json(json_string)
      hash =
        JSON
        .parse(json_string)
        .transform_keys(&:to_sym)
      variant_name = hash[:type]
      variant = variants.find { |v| v.name.gsub(/.*::/, '') == variant_name }
      raise ArgumentError, "Unable to find #{variant_name} for #{type.name}" unless variant

      variant.new(**hash.except(:type))
    end
  end
end
