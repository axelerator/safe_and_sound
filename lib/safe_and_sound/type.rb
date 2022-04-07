# frozen_string_literal: true

module SafeAndSound
  class BaseTypeCannotBeInstantiated < StandardError; end

  ##
  # base class for the newly defined types
  class Type
    def initialize
      raise BaseTypeCannotBeInstantiated, 'You cannot create instances of this type directly but only of its variants'
    end
  end
end
