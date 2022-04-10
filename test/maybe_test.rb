# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class MaybeTest < Minitest::Test
    def test_can_instantiate_nothing
      nothing = Maybe.Nothing
      refute_nil nothing
    end

    def test_can_instantiate_error
      just = Maybe.Just(value: 42)
      refute_nil just

      assert_equal 42, just.value
    end

    def test_with_default
      nothing = Maybe.Nothing
      just = Maybe.Just(value: 42)

      assert_equal 23, nothing.with_default(23)
      assert_equal 42, just.with_default(23)
    end

    def test_values
      nothing = Maybe.Nothing
      just = Maybe.Just(value: 42)

      assert_equal [42], Maybe.values([nothing, just])
    end
  end
end
