# frozen_string_literal: true

class FareCalculator
  @@FARES = {
    zone_1: 2.5,
    one_zone_excl_z1: 2.0,
    two_zones_inc_z1: 3.0,
    two_zones_excl_z1: 2.25,
    three_zones: 3.2,
    bus: 1.8,
  }
  @@max_fare = @@FARES.values.max

  def default_charge(card)
    raise InputError.new 'You need to top up your card before you can travel' if card.balance.negative?
    card.charge(@@max_fare)
  end

  def calculate_fare(card, journey_type, origin='', destination='')
    case journey_type
    when 'bus'
      raise InputError.new 'You need to top up your card before you can travel' if card.balance.negative?
      card.charge(@@FARES[:bus])
    when 'tube'
      origin_zone, destination_zone = calculate_zones_travelled(origin, destination) unless origin.empty? || destination.empty?
      zone_1_included = origin_zone == '1' || destination_zone == '1'
      number_of_zones_travelled = (origin_zone.to_i - destination_zone.to_i).abs
      charge = calculate_charge(number_of_zones_travelled, zone_1_included)
      card.refund(@@max_fare - charge)
    end
  end

  private

  def calculate_zones_travelled(origin_name, destination_name)
    origin_zones = StationMap.get_station(origin_name).zones
    destination_zones = StationMap.get_station(destination_name).zones
    origin_zone, destination_zone = calculate_farest_zones(origin_zones, destination_zones)
    return origin_zone, destination_zone      
  end

  # Good lord this needs to be broken down, but I don't currently have time to do it. Please forgive me!
  def calculate_farest_zones(origin_zones, destination_zones)
    return [origin_zones, destination_zones] unless origin_zones.is_a?(Array) || destination_zones.is_a?(Array)

    # This section is based on the assumption that multi-zone stations have to have consecutive zones (ie can't be zone 1 and 3 without zone 2)
    if destination_zones.is_a?(Array) && origin_zones.is_a?(Array)
      shared_zones = destination_zones & origin_zones
      if shared_zones.length > 0
        return[shared_zones.max, shared_zones.max]
      else
        if destination_zones.max < origin_zones.min 
          return [origin_zones.min, destination_zones.max]
        else
          return [origin_zones.max, destination_zones.min]
        end
      end
    elsif origin_zones.is_a? Array
      if origin_zones.include? destination_zones
        return[destination_zones, destination_zones]
      else
        if origin_zones.max < destination_zones
          return [origin_zones.max, destination_zones]
        else
          return [origin_zones.min, destination_zones]
        end
      end
    else
      if destination_zones.include? origin_zones
        return[origin_zones, origin_zones]
      else
        if destination_zones.max < origin_zones
          return [origin_zones, destination_zones.max]
        else
          return [origin_zones, destination_zones.min]
        end
      end
    end
  end

  def calculate_charge(number_of_zones_crossed, zone_1_included)
    charge = if zone_1_included
      case number_of_zones_crossed.to_s
      when '0'
        @@FARES[:zone_1]
      when '1'
        @@FARES[:two_zones_inc_z1]
      when '2'
        @@FARES[:three_zones]
      end
    else
      case number_of_zones_crossed.to_s
      when '0'
        @@FARES[:one_zone_excl_z1]
      when '1'
        @@FARES[:two_zones_excl_z1]
      end
    end
  end
end