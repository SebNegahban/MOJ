# frozen_string_literal: true

require_relative '../errors/input_error'

class Scanner
  attr_reader :current_card

  @@cards = {}

  def scan(card_number)
    unreadable_card if card_number.to_i == 0
    @current_card = get_card(card_number)
  end

  def register_card(card)
    card_already_registered if @@cards.has_value?(card.card_number)
    @@cards[card.card_number] = card
    @current_card = card
  end

  def clear_card
    @current_card = nil
  end

  private 

  def get_card(card_number)
    return @@cards[card_number] if @@cards[card_number]

    raise InputError.new('Card not found, please try again')
  end

  def unreadable_card
    # Add some kind of logging to track number of unreadable cards?
    raise InputError.new('Unreadable card, please try again')
  end

  def card_already_registered
    # Add notifier to card owner that their card has potentially been stolen
    raise InputError.new('Card already registered')
  end
end