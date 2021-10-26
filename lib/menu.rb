# frozen_string_literal: true

module Menu
  def find_card
    puts 'Please scan your card'
    puts '(For this demo, please enter your card number)'
    puts ''
    entered_card_number = gets.chomp
    return fetch_card_by_number(entered_card_number)
  end

  def fetch_card_by_number(card_number)
    card = @scanner.scan(card_number)
    return card
  end

  def clear_screen
    system('cls') || system('clear')
  end
end