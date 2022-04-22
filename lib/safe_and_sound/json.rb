# frozen_string_literal: true

require 'json'

module SafeAndSound
  module ToJson
    def as_json
      hash = { 'type' => self.class.variant_name.to_s }
      self.class.fields.each do |field_name, _|
        value = send(field_name)
        hash[field_name.to_s] =
          if value.is_a?(Array)
            value.map do |item|
              if item.respond_to?(:as_json)
                item.as_json
              else
                item
              end
            end
          elsif value.respond_to?(:as_json)
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
      from_hash(JSON.parse(json_string))
    end

    def from_hash(hash_)
      hash = hash_.transform_keys(&:to_sym)
      variant_name = hash[:type].to_sym if hash[:type]
      variant =
        if variant_name.nil? && variants.length == 1
          variants.first
        else
          variants.find { |v| v.variant_name == variant_name }
        end
      raise ArgumentError, "Unable to find #{variant_name} for #{name}" unless variant

      variant.new(**hash.except(:type))
    end
  end
end
