# frozen_string_literal: true

module SafeAndSound
  module ToJson
    def as_json
      hash = { 'type' => self.class.variant_name.to_s }
      self.class.fields.each do |field_name, _|
        hash[field_name.to_s] = send(field_name)
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
