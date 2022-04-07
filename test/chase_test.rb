# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class ChaseTest < Minitest::Test
    include Functions

    def test_that_chase_can_be_called
      type = SafeAndSound.new(Variant: {})

      variant = type::Variant.new

      result =
        chase variant do
          wenn type::Variant, -> { 42 }
        end

      assert_equal 42, result
    end

    def test_chase_with_multiple_branches
      type = SafeAndSound.new(A: {}, B: {})
      a = type::A.new
      b = type::B.new

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
  end
end
