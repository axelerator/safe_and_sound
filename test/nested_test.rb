# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class NestedTest < Minitest::Test
    def test_can_nest
      inner_type = SafeAndSound.new(InnerVariant: { innerField: Integer })
      outer_type = SafeAndSound.new(OuterVariant: { outerField: inner_type })

      inner_instance = inner_type.InnerVariant(innerField: 42)
      outer_instance = outer_type.OuterVariant(outerField: inner_instance)

      refute_nil outer_instance
      assert_equal 42, outer_instance.outerField.innerField
    end
  end
end

