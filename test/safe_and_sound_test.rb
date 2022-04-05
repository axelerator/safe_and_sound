# frozen_string_literal: true
require 'test_helper'

module SafeAndSound
  class SafeAndSoundTest < Minitest::Test

    def test_that_type_can_be_defined
      type = SafeAndSound.define :MyType

      assert_equal 'MyType', type.name
      refute_nil MyType
    end

    def test_that_type_name_must_be_sym
      assert_raises ArgumentError do
        SafeAndSound.define 'MyType'
      end
    end

    def test_that_type_can_be_defined_with_variants
       SafeAndSound
         .define(:MyTypeWithAField, AVariant: {})
    end
  end
end
