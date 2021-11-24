# frozen_string_literal: true

require_relative './zone_calculator'

# Calculates the fare for the travel taken by the user
class FareCalculator
  @@fares = {
    zone1: 2.5,
    one_zone_excl_z1: 2.0,
    two_zones_inc_z1: 3.0,
    two_zones_excl_z1: 2.25,
    three_zones: 3.2,
    bus: 1.8
  }
  @@max_fare = @@fares.values.max

  def initialize
    @zone_calculator = ZoneCalculator.new
  end

  def default_charge(card)
    raise InputError, 'You need to top up your card before you can travel' if card.balance.negative?

    card.charge(@@max_fare)
  end

  def calculate_fare(card, journey_type, origin = nil, destination = nil)
    case journey_type
    when 'bus'
      raise InputError, 'You need to top up your card before you can travel' if card.balance.negative?

      card.charge(@@fares[:bus])
    when 'tube'
      # I don't think this guard clause can ever be hit with the current setup, but here to be safe.
      raise InputError, 'You need to enter an origin and destination' unless origin && destination

      origin_zone, destination_zone = @zone_calculator.calculate_zones_travelled(origin, destination)
      zone_1_included = origin_zone == 1 || destination_zone == 1
      number_of_zones_travelled = (origin_zone - destination_zone).abs
      charge = calculate_charge(number_of_zones_travelled, zone_1_included)
      card.refund(@@max_fare - charge)
    end
  end

  private

  def calculate_charge(number_of_zones_travelled, zone_1_included)
    if zone_1_included
      case number_of_zones_travelled.to_s
      when '0'
        @@fares[:zone1]
      when '1'
        @@fares[:two_zones_inc_z1]
      when '2'
        @@fares[:three_zones]
      end
    else
      case number_of_zones_travelled.to_s
      when '0'
        @@fares[:one_zone_excl_z1]
      when '1'
        @@fares[:two_zones_excl_z1]
      end
    end
  end
end
