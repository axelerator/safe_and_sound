# frozen_string_literal: true

require '../lib/safe_and_sound'

##
# Main app
class Main
  include SafeAndSound::Functions

  def run # rubocop:disable Metrics/AbcSize
    nothing = SafeAndSound::Maybe.Nothing
    just_gold = SafeAndSound::Maybe.Just(value: 'Gold')
    just_silver = SafeAndSound::Maybe.Just(value: 'Silver')

    puts maybe_to_string(nothing)
    # nothing to see here
    puts maybe_to_string(just_gold)
    # Look what I found: Gold

    maybes = [just_silver, nothing, just_gold]
    values = SafeAndSound::Maybe.values(maybes)
    puts values.join(',')
    # Silver,Gold

    just1 = min([1, 2, 3])
    puts maybe_to_string(just1)
    # Look what I found: 1

    zero = min([]).with_default 0
    puts zero
    # 0
  end

  def maybe_to_string(maybe)
    chase maybe do
      wenn SafeAndSound::Maybe::Nothing, -> { 'nothing to see here' }
      wenn SafeAndSound::Maybe::Just, -> { "Look what I found: #{value}" }
    end
  end

  def min(array)
    if array.empty?
      SafeAndSound::Maybe.Nothing
    else
      SafeAndSound::Maybe.Just(value: array.min)
    end
  end
end

Main.new.run
