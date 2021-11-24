# frozen_string_literal: true

# Contains the information about a tube station.
class Station
  attr_reader :name, :zones

  def initialize(name, zones)
    @name = name
    @zones = zones
  end
end
