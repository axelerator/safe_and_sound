# frozen_string_literal: true
require 'test_helper'

class SafeAndSoundTest < Minitest::Test

  def test_that_kitty_can_eat
    assert_equal "0.0.1", SafeAndSound::VERSION
  end

end
