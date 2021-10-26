# frozen_string_literal: true

require_relative '../errors/input_error'

class Card
  attr_reader :card_number, :balance

  def initialize(card_number)
    @card_number = card_number
    @balance = 0
  end

  def top_up(funds)
    funds = funds.to_f.floor(2)
    raise InputError.new('Entered amount cannot be negative') if funds.negative?
    @balance += funds
    return funds
  end

  def charge(amount)
    @balance -= amount
  end

  # Superfluous, but makes the code easier to read in my opinion.
  def refund(amount)
    top_up(amount)
  end
end