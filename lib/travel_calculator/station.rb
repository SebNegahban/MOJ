# frozen_string_literal: true

class Station
  attr_reader :name, :zones

  def initialize(name, zones)
    @name = name
    @zones = zones
  end
end