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
  end
end
