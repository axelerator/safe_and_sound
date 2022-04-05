# frozen_string_literal: true

require 'safe_and_sound/version'

##
# Namespace for the safe_and_sound classes
module SafeAndSound
  def self.define(type_name, *variants)
    raise ArgumentError.new "type_name must be a Symbol" unless type_name.is_a?(Symbol)
    new_type = Class.new
    Object.const_set(type_name, new_type)

    new_type
  end
end
