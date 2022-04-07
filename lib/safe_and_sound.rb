# frozen_string_literal: true

require 'safe_and_sound/type'
require 'safe_and_sound/variant'
require 'safe_and_sound/version'

##
# Namespace for the safe_and_sound classes
module SafeAndSound
  def self.define(**variants)
    new_type = Class.new(Type)

    variants =
      variants.map do |variant_name, fields|
        Variant.build(variant_name, fields, new_type)
      end

    new_type
  end
end
