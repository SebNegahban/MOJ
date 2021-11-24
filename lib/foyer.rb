# frozen_string_literal: true

require_relative './menu'
require_relative './top_up_kiosk/kiosk_menu'
require_relative './travel_calculator/station_map'
require_relative './travel_calculator/station'
require_relative './travel_calculator/journey_menu'

# The opening menu, representing the foyer of the tube station or bus stop
class Foyer
  include Menu

  def initialize
    build_station_map
  end

  def display_welcome
    print_menu(
      ['Please select an option: '],
      ['Visit the top-up kiosk', 'Go on a journey', 'Leave the station']
    )
    option_selected = $stdin.gets.chomp
    clear_screen
    handle_input(option_selected)
    clear_screen
    display_welcome
  end

  private

  def build_station_map
    StationMap.build_map
  end

  def handle_input(option_selected)
    case option_selected
    when '1'
      KioskMenu.new.display_welcome
    when '2'
      JourneyMenu.new.display_welcome
    when '3'
      exit(0)
    else
      puts 'Invalid selection, please try again.'
      puts ''
      display_welcome
    end
  end
end
