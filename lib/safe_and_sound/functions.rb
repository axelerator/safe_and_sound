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

  class MatchedChaseValueNotAVariant < StandardError; end
  class MissingChaseBranch < StandardError; end
  class DuplicateChaseBranch < StandardError; end
  class ChaseValueNotAVariant < StandardError; end

  ##
  # Instance represent one application of a 'chase'
  # statement.
  class Chase
    NO_MATCH = Object.new
    NO_FALLBACK = Object.new

    def initialize(object)
      unless object.respond_to?(:variant_type?)
        raise ChaseValueNotAVariant,
              "Matched value in chase expression must be a variant but is a #{object.class.name}"
      end

      @result = NO_MATCH
      @object = object
      @to_match = object.class.superclass.variants.dup
      @otherwise = NO_FALLBACK
    end

    def run(block)
      instance_eval(&block)
      unless @to_match.empty? || @otherwise != NO_FALLBACK
        raise MissingChaseBranch,
              "Missing branches for variants: #{@to_match.map(&:variant_name).join(',')}"
      end
      return @otherwise if @result == NO_MATCH

      @result
    end

    def wenn(variant, lmda)
      unless variant.is_a?(Class) && variant.superclass == @object.class.superclass
        raise MatchedChaseValueNotAVariant,
              "The value matched against must be a variant of #{@object.class.superclass.name} "\
              "but is a #{variant.class}"
      end
      unless @to_match.delete(variant)
        raise DuplicateChaseBranch,
              "There are multiple branches for variant: #{variant.variant_name}"
      end
      return unless @result == NO_MATCH

      @result = @object.instance_exec(&lmda) if @object.is_a? variant
    end

    def otherwise(value)
      @otherwise = value.call
    end
  end
end
