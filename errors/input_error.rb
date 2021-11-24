# frozen_string_literal: true

# Custom error class for this project to prevent other error types from being caught
class InputError < ArgumentError
  def initialize(message = 'Invalid input.')
    super(message)
  end
end
