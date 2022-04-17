# frozen_string_literal: true

require 'safe_and_sound/json'

module SafeAndSound
  class BaseTypeCannotBeInstantiated < StandardError; end

  ##
  # base class for the newly defined types
  class Type
    extend FromJson

    def initialize
      raise BaseTypeCannotBeInstantiated, 'You cannot create instances of this type directly but only of its variants'
    end

    class << self
      attr_accessor :variants
    end
  end
end
