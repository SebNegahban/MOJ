# frozen_string_literal: true

require 'csv'
require_relative './station'
require_relative '../../errors/input_error'

class StationMap

  @@stations = {}

  def self.build_map
    CSV.read("./fixtures/stations.csv").each do |station_import_line|
      station_name, station_zones = station_import_line
      station_zones = station_zones.split(',')
      station_zones = station_zones[0] if station_zones.size == 1
      @@stations[station_name.downcase] = Station.new(station_name, station_zones)
    end
  end

  def self.get_station(station_name)
    return @@stations[station_name.downcase] if @@stations[station_name.downcase]

    raise InputError.new('Station not found, please try again')
  end
end