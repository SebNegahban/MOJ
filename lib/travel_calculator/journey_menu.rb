# frozen_string_literal: true

require_relative '../menu'
require_relative './fare_calculator'
require_relative '../../errors/input_error'

class JourneyMenu
  include Menu

  def initialize
    @scanner = Scanner.new
    @fare_calculator = FareCalculator.new
    actions
  end

  private

  def actions
    puts 'Please select what you would like to do: '
    puts ''
    puts '  1. Swipe in for tube station'
    puts '  2. Swipe out for tube station'
    puts '  3. Swipe in for bus'
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
      actions
    end
  end 

  def handle_input(option_selected)
    case option_selected
    when '1'
      @origin = get_origin
      card = find_card
      @fare_calculator.default_charge(card)
      actions
    when '2'
      @destination = get_destination
      card = find_card
      @fare_calculator.calculate_fare(card, 'tube', @origin, @destination) if card
      actions
    when '3'
      card = find_card
      @fare_calculator.calculate_fare(card, 'bus') if card
      actions
    when '4'
      @scanner.clear_card
    else
      puts 'Invalid selection, please try again.'
      puts ''
      actions
    end
  end

  def get_origin
    puts 'Please enter your station of origin: '
    puts ''
    station_name = gets.chomp
    StationMap.get_station(station_name)
    return station_name
  end

  def get_destination
    raise InputError.new 'You must select an origin before selecting a destination.' unless @origin
    
    puts 'Please enter your destination station: '
    puts ''
    station_name = gets.chomp
    StationMap.get_station(station_name)
    return station_name
  end
end