# frozen_string_literal: true

require_relative '../scanner'
require_relative '../card'
require_relative '../menu'
require_relative '../../errors/input_error'

# Acts as a Oyster Card kiosk for registering, topping up, and checking the balance of cards.
class KioskMenu
  include Menu

  def initialize
    @scanner = Scanner.new
  end

  def display_welcome
    print_menu(
      ['Welcome, please select an option: '],
      ['Register a new card', 'Top-up an existing card', 'Check balance', 'Exit']
    )
    option_selected = $stdin.gets.chomp
    clear_screen
    begin
      handle_input(option_selected)
    rescue InputError => e
      clear_screen
      puts e.message
      puts ''
      display_welcome
    end
  end

  private

  def handle_input(option_selected)
    case option_selected
    when '1'
      register_card
    when '2'
      top_up_card
    when '3'
      check_balance
    when '4'
      exit_menu
    else
      puts 'Invalid selection, please try again.'
      puts ''
      display_welcome
    end
  end

  # Were this a real-world situation with physical cards, there would be a distinction between
  # card creation and card registering, hence the existence of Scanner#card_already_registered.
  # In this solution however, cleanly creating trackable cards without 'registering' them to a user (or in this
  # case adding them to a constant hash in Scanner) would involve a lot of messy constants and collections
  # that are implicitly handled in real life. As such, I thought it best to not worry too much about the
  # difference between card creation and registration, and instead to make #register_card to encompass them both.
  def register_card
    @scanner.register_card(Card.new)
    clear_screen
    puts 'Card registered.'
    puts "Your card number is: #{@scanner.current_card.card_number}"
    puts ''
    display_welcome
  end

  def top_up_card
    card = @scanner.current_card || find_card
    puts 'Please enter how much you would like to top-up by in GBP: '
    puts ''
    amount = $stdin.gets.chomp
    added_amount = card.top_up(amount)
    clear_screen
    puts "Card topped up by £#{format('%.2f', added_amount)}, thank you and have a safe journey."
    display_welcome
  end

  def check_balance
    card = @scanner.current_card || find_card
    puts "Your current balance is: £#{format('%.2f', card.balance)}"
    puts ''
    puts 'Press any key to continue.'
    $stdin.gets.chomp
    clear_screen
    display_welcome
  end

  def exit_menu
    @scanner.clear_card
  end
end
