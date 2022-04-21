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

    def test_serialize_nested
      inner_type = SafeAndSound.new(InnerVariant: { innerField: Integer })
      outer_type = SafeAndSound.new(OuterVariant: { outerField: inner_type })

      inner_instance = inner_type.InnerVariant(innerField: 42)
      outer_instance = outer_type.OuterVariant(outerField: inner_instance)

      inner_hash =
        { 'type' => 'InnerVariant',
          'innerField' => 42 }
      outer_hash =
        { 'type' => 'OuterVariant',
          'outerField' => inner_hash }

      refute_nil outer_instance
      assert_equal outer_hash, outer_instance.as_json
    end

    def test_deserialization
      type = SafeAndSound
             .new(AVariant: { aField: String })
      input_hash =
        { 'type' => 'AVariant',
          'aField' => 'Foo' }
      variant = type.from_json(input_hash.to_json)
      assert_kind_of type.const_get(:AVariant), variant
    end

    def test_nested_deserialization
      inner_type = SafeAndSound.new(InnerVariant: { innerField: Integer })
      outer_type = SafeAndSound.new(OuterVariant: { outerField: inner_type })

      inner_hash =
        { 'type' => 'InnerVariant',
          'innerField' => 42 }
      outer_hash =
        { 'type' => 'OuterVariant',
          'outerField' => inner_hash }

      variant = outer_type.from_hash(outer_hash)
      assert_kind_of outer_type.const_get(:OuterVariant), variant
    end


    def test_deserialization_for_singular_type
      type = SafeAndSound
             .new(AVariant: { aField: String })
      input_hash =
        { 'aField' => 'Foo' }
      variant = type.from_json(input_hash.to_json)
      assert_kind_of type.const_get(:AVariant), variant
    end
  end
end
