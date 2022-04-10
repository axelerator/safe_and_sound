# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class ResultTest < Minitest::Test
    def test_can_instantiate_ok
      ok = Result.Ok(value: 42)
      refute_nil ok
      assert_equal 42, ok.value
    end

    def test_can_instantiate_error
      err = Result.Err(error: 'reason')
      refute_nil err

      assert_equal 'reason', err.error
    end
  end
end
