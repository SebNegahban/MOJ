# frozen_string_literal: true

# Contains shared methods of the menus within the program
module Menu
  def find_card
    print_menu(['Please scan your card', '(For this demo, please enter your card number)'])
    entered_card_number = $stdin.gets.chomp
    return @scanner.scan(entered_card_number)
  end

  def print_menu(welcome_messages = [], menu_options = [])
    welcome_messages.each { |message| puts message }
    puts '' unless welcome_messages.empty?
    menu_options.each_with_index { |option, index| puts "  #{index + 1}. #{option}" }
    puts '' unless menu_options.empty?
  end

  def clear_screen
    system('cls') || system('clear')
  end
end
