# frozen_string_literal: true

require 'safe_and_sound/variant'
require 'safe_and_sound/version'

##
# Namespace for the safe_and_sound classes
module SafeAndSound
  def self.define(type_name, **variants)
    raise ArgumentError, 'type_name must be a Symbol' unless type_name.is_a?(Symbol)

    new_type = Class.new
    Object.const_set(type_name, new_type)

    variants = variants.map do |variant_name, _fields|
      new_variant = Class.new(Variant)
      new_type.const_set(variant_name.to_s, new_variant)
      new_variant
    end

    new_type
  end
end
