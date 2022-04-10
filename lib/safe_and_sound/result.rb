# frozen_string_literal: true

module SafeAndSound
  Result = SafeAndSound.new(
    Ok: { value: Object },
    Err: { error: Object }
  )
  ##
  # Module with methods we want to add to our Result type
  module ResultMethods
    def and_then(&block)
      chase self do
        wenn Result::Ok, ->  { block.call(value) }
        wenn Result::Err, -> { self }
      end
    end
  end
  Result.include ResultMethods
end
