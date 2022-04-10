# frozen_string_literal: true

module SafeAndSound
  Maybe = SafeAndSound.new(
    Just: { value: Object },
    Nothing: {}
  )

  module MaybeMethods
    def with_default(default)
      chase self do
        wenn Maybe::Just, -> { value }
        wenn Maybe::Nothing, -> { default }
      end
    end
  end

  module MaybeClassMethods
    include SafeAndSound::Functions
    def values(maybes)
      maybes.inject([]) do |sum, maybe|
        chase maybe do
          wenn Maybe::Just, -> { sum.push(value) }
          wenn Maybe::Nothing, -> { sum }
        end
      end
    end
  end
  Maybe.include(MaybeMethods)
  Maybe.extend(MaybeClassMethods)
end
