# frozen_string_literal: true

require_relative '../errors/input_error'

# A representation of the card scanners found at tube station gates, top up kiosks,
# and buses.
# Tracks the currently scanned card for Top Up Kiosks, so the user doesn't have to repeatedly scan in one session.
class Scanner
  attr_reader :current_card

  @@cards = {}

  def scan(card_number)
    unreadable_card if card_number.to_i.zero?
    @current_card = get_card(card_number)
  end

  def register_card(card)
    card_already_registered if @@cards.key?(card.card_number)
    @@cards[card.card_number] = card
    @current_card = card
  end

  def clear_card
    @current_card = nil
  end

  private

  def get_card(card_number)
    return @@cards[card_number] if @@cards[card_number]

    raise InputError, 'Card not found, please try again'
  end

  def unreadable_card
    # Add some kind of logging to track number of unreadable cards
    raise InputError, 'Unreadable card, please try again'
  end

  def card_already_registered
    # Add notifier to card owner that their card has potentially been stolen
    raise InputError, 'Card already registered'
  end
end
