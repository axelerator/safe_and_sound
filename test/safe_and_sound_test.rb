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

      variant = MyTypeWithAField::AVariant.new
      refute_nil variant
    end

    def test_that_variant_can_has_fields
      SafeAndSound
        .define(:TypeWithAField, AVariant: { aField: String })

      variant = TypeWithAField::AVariant.new(aField: 'Foo')

      assert_equal 'Foo', variant.aField
    end

    def test_that_variant_expects_exact_fields
      SafeAndSound.define(:TypeWithTwoFields,
                          AVariant: { aField: String, anotherField: Integer })

      assert_raises MissingConstructorArg do
        TypeWithTwoFields::AVariant.new(aField: 'Foo')
      end

      assert_raises UnknownConstructorArg do
        TypeWithTwoFields::AVariant.new(aField: 'Foo', anotherField: 42, notAField: 23)
      end
    end
  end
end
