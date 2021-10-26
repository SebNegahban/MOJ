# frozen_string_literal: true

require_relative '../scanner'
require_relative '../card'
require_relative '../menu'
require_relative '../../errors/input_error'

class KioskMenu
  include Menu

  def initialize
    @scanner = Scanner.new
    display_welcome
  end

  def display_welcome
    puts 'Welcome, please select an option: '
    puts ''
    puts '  1. Register a new card'
    puts '  2. Top-up an existing card'
    puts '  3. Check balance'
    puts '  4. Exit'
    puts ''
    option_selected = gets.chomp
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
      puts 'Invalid entry, please try again'
      puts ''
      display_welcome
    end
  end

  def register_card
    puts 'Please scan your card'
    puts ''
    @scanner.register_card(Card.new((rand(100000)+1).to_s))
    clear_screen
    puts 'Card registered.'
    puts "Your card number is: #{@scanner.current_card.card_number}"
    puts ''
    display_welcome
  end

  def top_up_card
    card = @scanner.current_card ? @scanner.current_card : find_card
    puts 'Please enter how much you would like to top-up by in GBP: '
    puts ''
    amount = gets.chomp
    added_amount = card.top_up(amount)
    clear_screen
    puts "Card topped up by £#{sprintf("%.2f", added_amount)}, thank you and have a safe journey."
    display_welcome
  end

  def check_balance
    card = @scanner.current_card ? @scanner.current_card : find_card
    puts "Your current balance is: £#{sprintf("%.2f", card.balance)}"
    puts ''
    puts 'Press any key to continue.'
    gets.chomp
    clear_screen
    display_welcome
  end

  def exit_menu
    @scanner.clear_card
  end
end