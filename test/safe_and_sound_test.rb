# frozen_string_literal: true

require 'test_helper'

module SafeAndSound
  class SafeAndSoundTest < Minitest::Test
    def test_that_type_can_be_defined
      type = SafeAndSound.define

      refute_nil type

      assert_raises BaseTypeCannotBeInstantiated do
        type.new
      end
    end

    def test_that_type_can_be_defined_with_variants
      type = SafeAndSound.define(AVariant: {})

      variant = type::AVariant.new
      refute_nil variant
    end

    def test_that_variant_can_has_fields
      type = SafeAndSound
             .define(AVariant: { aField: String })

      variant = type::AVariant.new(aField: 'Foo')

      assert_equal 'Foo', variant.aField
    end

    def test_that_variant_expects_exact_fields
      type =
        SafeAndSound.define(AVariant: { aField: String, anotherField: Integer })

      assert_raises MissingConstructorArg do
        type::AVariant.new(aField: 'Foo')
      end

      assert_raises UnknownConstructorArg do
        type::AVariant.new(aField: 'Foo', anotherField: 42, notAField: 23)
      end
    end

    def test_that_variant_expects_fields_of_correct_type
      type =
        SafeAndSound.define(AVariant: { aString: String })

      assert_raises WrgonConstructorArgType do
        type::AVariant.new(aString: 42)
      end
    end

    def test_that_variants_are_subclasses_of_type
      type = SafeAndSound
             .define(Variant: {})

      variant = type::Variant.new

      assert variant.is_a?(type)
    end
  end
end
