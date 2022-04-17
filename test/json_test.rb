# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class SafeAndSoundTest < Minitest::Test
    def test_serialization_works
      type = SafeAndSound
             .new(AVariant: { aField: String })

      variant = type::AVariant.new(aField: 'Foo')

      expected_hash =
        { 'type' => 'AVariant',
          'aField' => 'Foo' }

      assert_equal expected_hash, variant.as_json
    end
  end
end
