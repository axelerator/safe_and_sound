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
  Maybe.include(MaybeMethods)
end
