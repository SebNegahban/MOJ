# frozen_string_literal: true

class ZoneCalculator

  def initialize
    @origin_zone
    @destination_zone
  end

  def calculate_zones_travelled(origin, destination)
    calculate_farest_zones(origin.zones, destination.zones)
    return @origin_zone, @destination_zone      
  end

  private

  def calculate_farest_zones(origin_zones, destination_zones)
    unless origin_zones.is_a?(Array) || destination_zones.is_a?(Array)
      @origin_zone = origin_zones
      @destination_zone = destination_zones
      return
    end

    # This section is based on the assumption that multi-zone stations have to have consecutive zones (ie can't be zone 1 and 3 without zone 2)
    if destination_zones.is_a?(Array) && origin_zones.is_a?(Array)
      origin_and_destination_multizone(origin_zones, destination_zones)
    elsif origin_zones.is_a? Array
      one_multizone_one_singlezone(origin_zones, destination_zones)
    else
      one_multizone_one_singlezone(destination_zones, origin_zones)
    end
  end

  def origin_and_destination_multizone(origin_zones, destination_zones)
    shared_zones = destination_zones & origin_zones
    if shared_zones.length > 0
      # This ensures the 'farest' fare, ensuring that zone 1 is not paid for when travel can be interpreted
      # as outside zone 1
      @origin_zone = shared_zones.max
      @destination_zone = shared_zones.max
    else
      if destination_zones.max < origin_zones.min 
        @origin_zone = origin_zones.min
        @destination_zone = destination_zones.max
      else
        @origin_zone = origin_zones.max
        @destination_zone = destination_zones.min
      end
    end
  end

  # Technically this will always return the multizone station as the origin, and the single zone station as the destination.
  # Currently, this is not a problem as there is no distinction in fare charge between direction of travel.
  # If an additional charge/ rebate were added depending on direction of travel, this refactor would need to be reverted.
  def one_multizone_one_singlezone(station_1_zones, station_2_zone)
    if station_1_zones.include? station_2_zone
      @origin_zone = station_2_zone
      @destination_zone = station_2_zone
    else
      if station_1_zones.max < station_2_zone
        @origin_zone = station_1_zones.max
        @destination_zone = station_2_zone
      else
        @origin_zone = station_1_zones.min
        @destination_zone = station_2_zone
      end
    end
  end
end