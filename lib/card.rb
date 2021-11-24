# frozen_string_literal: true

require_relative '../errors/input_error'

# Representation of an Oyster card, handles the balance and card number.
class Card
  attr_reader :card_number, :balance

  def initialize
    @card_number = rand(1..100000).to_s
    @balance = 0
  end

  def top_up(funds)
    funds = funds.to_f.floor(2)
    raise InputError, 'Entered amount cannot be negative' if funds.negative?

    @balance += funds
    return funds
  end

  def charge(amount)
    # Prevents a situation where a card can be topped-up using #charge
    raise InputError, 'Entered amount cannot be negative' if amount.negative?

    @balance -= amount
  end

  # Superfluous, but makes the code easier to read in my opinion.
  def refund(amount)
    top_up(amount)
  end
end
