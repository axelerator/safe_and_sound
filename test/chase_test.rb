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
  end
end
