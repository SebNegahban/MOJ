# frozen_string_literal: true

require_relative '../menu'
require_relative './fare_calculator'
require_relative '../../errors/input_error'

# Gets the origin and destination of the user's journey
class JourneyMenu
  include Menu

  def initialize
    @scanner = Scanner.new
    @fare_calculator = FareCalculator.new
  end

  def display_welcome
    print_menu(
      ['Please select what you would like to do: '],
      ['Swipe in for tube station', 'Swipe out for tube station', 'Swipe in for bus', 'Exit']
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
      fetch_origin
    when '2'
      fetch_destination
    when '3'
      take_bus
    when '4'
      exit_menu
    else
      puts 'Invalid selection, please try again.'
      puts ''
      display_welcome
    end
  end

  def fetch_origin
    @origin = find_station

    # Catches issue where if you entered an origin then purposefully failed the card lookup or had a negative card
    # balance, you could gain funds on your card because you were never charged but gained the 'refund' from the
    # post-travel calculation.
    begin
      card = find_card
      @fare_calculator.default_charge(card)
    rescue InputError
      @origin = nil
      raise
    end

    display_welcome
  end

  def fetch_destination
    raise InputError, 'You must select an origin before selecting a destination.' unless @origin

    @destination = find_station
    card = find_card
    @fare_calculator.calculate_fare(card, 'tube', @origin, @destination) if card
    display_welcome
  end

  def take_bus
    card = find_card
    @fare_calculator.calculate_fare(card, 'bus') if card
    display_welcome
  end

  def find_station
    puts 'Please enter the name of the station: '
    puts ''
    station_name = $stdin.gets.chomp
    clear_screen
    return StationMap.find_station(station_name)
  end

  def exit_menu
    @scanner.clear_card
  end
end
