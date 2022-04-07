# frozen_string_literal: true

require '../lib/safe_and_sound'

Result = SafeAndSound.new(
  Ok: { value: Object },
  Err: { msg: String }
)

##
# Main app
class Main
  include SafeAndSound::Functions

  def run # rubocop:disable Metrics/AbcSize
    ok = Result.Ok value: 42
    error = Result.Err msg: 'Something went wrong!'

    puts result_to_s(ok)
    # Success! 42

    puts result_to_s(error)
    # BAM! Something went wrong!

    puts result_to_s(to_int('20'))
    # Success! 20

    puts result_to_s(to_int('foo'))
    # BAM! foo is not a number

    puts result_to_s(
      and_then(to_int('11')) { |i| to_valid_month(i) }
    )
    # Success! Nov

    puts result_to_s(
      and_then(to_int('42')) { |i| to_valid_month(i) }
    )
    # BAM! must be a integer between 1 and 12

    puts
    to_int('11')
      .and_then { |i| to_valid_month_num(i) }
      .and_then { |i| to_month_name(i) }
    # Success! Nov
  end

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

  def result_to_s(result)
    chase result do
      wenn Result::Ok, ->  { "Success! #{value}" }
      wenn Result::Err, -> { "BAM! #{msg}" }
    end
  end

  def and_then(result, &block)
    chase result do
      wenn Result::Ok, ->  { block.call(value) }
      wenn Result::Err, -> { result }
    end
  end

  def to_int(str)
    Result.Ok value: Integer(str)
  rescue ArgumentError
    Result.Err msg: "#{str} is not a number"
  end

  MONTHS =
    %i[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

  def to_valid_month(int)
    if int >= 1 && int <= 12
      Result.Ok value: MONTHS[int - 1]
    else
      Result.Err msg: 'must be a integer between 1 and 12'
    end
  end

  def to_valid_month_num(int)
    if int >= 1 && int <= 12
      Result.Ok value: int
    else
      Result.Err msg: 'must be a integer between 1 and 12'
    end
  end

  def to_month_name(int)
    Result.Ok value: MONTHS[int - 1]
  end
end

Main.new.run
