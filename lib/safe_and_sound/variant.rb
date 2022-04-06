# frozen_string_literal: true

module SafeAndSound
  ##
  # base class for a variant of the newly defined types
  class Variant
    def initialize(**args)
      args.each do |field_name, value|
        instance_variable_set("@#{field_name}", value)
      end
    end

    class << self
      attr_accessor :fields
    end
  end
end
