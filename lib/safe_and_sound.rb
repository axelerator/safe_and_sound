# frozen_string_literal: true

require 'safe_and_sound/type'
require 'safe_and_sound/variant'
require 'safe_and_sound/version'

##
# Namespace for the safe_and_sound classes
module SafeAndSound
  def self.define(type_name, **variants)
    raise ArgumentError, 'type_name must be a Symbol' unless type_name.is_a?(Symbol)

    new_type = Class.new(Type)
    Object.const_set(type_name, new_type)

    variants =
      variants.map do |variant_name, fields|
        Variant.build(variant_name, fields, new_type)
      end

    new_type
  end
end
