# frozen_string_literal: true

require '../lib/safe_and_sound'

##
# Main app
class Main
  include SafeAndSound::Functions

  def run
    ok = SafeAndSound::Result.Ok value: 42
    error = SafeAndSound::Result.Err error: 'Something went wrong!'

    puts result_to_s(ok)
    # Success! 42

    puts result_to_s(error)
    # BAM! Something went wrong!

    puts result_to_s(to_int('20'))
    # Success! 20

    puts result_to_s(to_int('foo'))
    # BAM! foo is not a number

    result =
      to_int('11')
      .and_then { |i| to_valid_month_num(i) }
      .and_then { |i| to_month_name(i) }
    puts result_to_s(result)
    # Success! Nov

    result =
      to_int('42')
      .and_then { |i| to_valid_month_num(i) }
      .and_then { |i| to_month_name(i) }
    puts result_to_s(result)
    # BAM! must be a integer between 1 and 12
  end

  def result_to_s(result)
    chase result do
      wenn SafeAndSound::Result::Ok, ->  { "Success! #{value}" }
      wenn SafeAndSound::Result::Err, -> { "BAM! #{error}" }
    end
  end

  ##
  # @return Ok(value: Integer) if string can be parsed into an integer
  # @return  Error(error: String) if string is not a valid integer
  #
  def to_int(str)
    SafeAndSound::Result.Ok value: Integer(str)
  rescue ArgumentError
    SafeAndSound::Result.Err error: "#{str} is not a number"
  end

  MONTHS =
    %i[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

  ##
  # @return Ok(value: Integer) if input integer is beteween 1 and 12
  # @return  Error(error: String) if input is outside valid range
  #
  def to_valid_month_num(int)
    if int >= 1 && int <= 12
      SafeAndSound::Result.Ok value: int
    else
      SafeAndSound::Result.Err error: 'must be a integer between 1 and 12'
    end
  end

  ##
  # Expects [int] to be a valid month number and always returns a month name
  def to_month_name(int)
    SafeAndSound::Result.Ok value: MONTHS[int - 1]
  end
end

Main.new.run
