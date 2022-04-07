# frozen_string_literal: true

module SafeAndSound
  ##
  # Include this module to get access to functions that
  # work on the algebraic data types.
  module Functions
    ##
    # This is an interpretation of Ruby's case statement for
    # ADTs.
    def chase(value, &block)
      Chase.new(value).run(block)
    end
  end

  ##
  # Instance represent one application of a 'chase'
  # statement.
  class Chase
    NO_MATCH = Object.new

    def initialize(object)
      @result = NO_MATCH
      @object = object
      @matched = []
    end

    def run(block)
      instance_eval(&block)
      @result
    end

    def wenn(variant, lmda)
      return unless @result == NO_MATCH

      @result = @object.instance_exec(&lmda) if @object.is_a? variant
      @matched << variant
    end
  end
end
