# frozen_string_literal: true

class InputError < ArgumentError
  def initialize(message="Invalid input.")
    super(message)
  end
end