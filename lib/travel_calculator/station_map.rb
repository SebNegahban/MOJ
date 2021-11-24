# frozen_string_literal: true

require 'csv'
require_relative './station'
require_relative '../../errors/input_error'

# Builds a hash of all of the stations and stores them for reference.
class StationMap
  @@stations = {}

  def self.build_map
    CSV.read('./fixtures/stations.csv').each do |station_import_line|
      station_name, station_zones = station_import_line
      station_zones = station_zones.split(',').map(&:to_i)
      station_zones = station_zones[0] if station_zones.size == 1
      @@stations[station_name.downcase] = Station.new(station_name, station_zones)
    end
  end

  def self.find_station(station_name)
    return @@stations[station_name.to_s.downcase] if @@stations[station_name.to_s.downcase]

    raise InputError, 'Station not found, please try again'
  end
end
