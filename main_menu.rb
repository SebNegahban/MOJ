# frozen_string_literal: true

require_relative './lib/top_up_kiosk/kiosk_menu'
require_relative './lib/travel_calculator/station_map'
require_relative './lib/travel_calculator/station'
require_relative './lib/travel_calculator/journey_menu'

class MainMenu

  def initialize
    build_station_map
    options
  end

  def options
    puts 'Please select an option: '
    puts ''
    puts '  1. Visit the top-up kiosk'
    puts '  2. Go on a journey'
    puts '  3. Leave the station'
    puts ''
    option_selected = gets.chomp
    clear_screen
    case option_selected
    when '1'
      KioskMenu.new
    when '2'
      JourneyMenu.new
    when '3'
      exit(0)
    else
      puts 'Invalid selection, please try again.'
      puts ''
      options
    end
    clear_screen
    options
  end

  private

  def clear_screen
    system('cls') || system('clear')
  end

  def build_station_map
    StationMap.build_map
  end
end

MainMenu.new