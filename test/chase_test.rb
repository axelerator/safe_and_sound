# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class ChaseTest < Minitest::Test
    include Functions

    def test_that_chase_can_be_called
      type = SafeAndSound.new(Variant: {})

      variant = type.Variant

      result =
        chase variant do
          wenn type::Variant, -> { 42 }
        end

      assert_equal 42, result
    end

    def test_chase_with_multiple_branches
      type = SafeAndSound.new(A: {}, B: {})
      a = type.A
      b = type.B

      assert_equal(42,
                   chase(a) do
                     wenn type::A, -> { 42 }
                     wenn type::B, -> { -42 }
                   end)

      assert_equal(-42,
                   chase(b) do
                     wenn type::A, -> { 42 }
                     wenn type::B, -> { -42 }
                   end)
    end

    def test_that_chase_raises_on_missing_branches
      type = SafeAndSound.new(Variant: {}, MissingVariant: {})

      variant = type.Variant

      assert_raises MissingChaseBranch do
        chase variant do
          wenn type::Variant, -> { 42 }
        end
      end
    end

    def test_that_chase_raises_on_duplicate_branches
      type = SafeAndSound.new(Variant: {})

      variant = type.Variant

      assert_raises DuplicateChaseBranch do
        chase variant do
          wenn type::Variant, -> { 42 }
          wenn type::Variant, -> { -42 }
        end
      end
    end

    def test_that_otherwise_covers_missing_branches
      type = SafeAndSound.new(Variant: {}, MissingVariant: {})

      variant = type.MissingVariant

      assert_equal(42,
                   chase(variant) do
                     wenn type::Variant, -> { 0 }
                     otherwise -> { 42 }
                   end)
    end

    def test_that_variant_fields_can_be_accessed_in_match_expression
      type = SafeAndSound.new(Variant: { field: Integer })

      variant = type.Variant field: 22

      assert_equal(42,
                   chase(variant) do
                     wenn type::Variant, -> { field + 20 }
                   end)
    end

    def test_that_chase_raises_if_not_matched_against_variant
      type = SafeAndSound.new(Variant: {})

      assert_raises ChaseValueNotAVariant do
        chase(42) do
          wenn type::Variant, -> { 0 }
        end
      end
    end

    def test_that_chase_raises_if_match_value_not_a_variant
      type = SafeAndSound.new(Variant: {})

      assert_raises MatchedChaseValueNotAVariant do
        chase(type.Variant) do
          wenn 'not_a_variant', -> { 0 }
        end
      end
    end
  end
end
