# frozen_string_literal: true

RSpec.describe ZoneCalculator do
  describe '#calculate_zones_travelled' do
    it 'returns the zones if both stations are only in a single zone' do
      origin = Station.new('Hammersmith', 2)
      destination = Station.new('Wimbledon', 3)
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([2, 3])
    end

    it 'finds the overlapping zone in two arrays of zones' do
      origin = Station.new('Archway', [2, 3])
      destination = Station.new("Earl's Court", [1, 2])
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([2, 2])
    end

    it 'finds the overlap between array of zones and single zone' do
      origin = Station.new("Earl's Court", [1, 2])
      destination = Station.new('Holborn', 1)
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([1, 1])
    end

    it 'finds the nearest between non-overlapping array of zones and single zone' do
      origin = Station.new('Wimbledon', 3)
      destination = Station.new("Earl's Court", [1, 2])
      # NOTE: Array of zones is always returned as the origin, see comment in ZoneCalculator
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([2, 3])
    end

    it 'finds the nearest two zones between two arrays' do
      origin = Station.new("Earl's Court", [1, 2])
      # Zone 4 is not currently supported by the FareCalculator in all scenarios but it's useful for demonstration
      # and it can be handled by the zone calculator
      destination = Station.new('Bounds Green', [3, 4])
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([2, 3])
    end

    it 'finds the highest shared zone when the two stations share the same zones' do
      origin = Station.new("Earl's Court", [1, 2])
      destination = Station.new("Earl's Court", [1, 2])
      expect(subject.calculate_zones_travelled(origin, destination)).to eq([2, 2])
    end

    context 'edge case testing' do
      it 'finds the highest shared zone in extreme situations' do
        origin = Station.new('Extreme Station 1', [1, 2, 3])
        destination = Station.new('Extreme Station 2', [2, 3, 4])
        expect(subject.calculate_zones_travelled(origin, destination)).to eq([3, 3])
      end

      it 'finds the nearest two zones between two extremes' do
        origin = Station.new('Extreme Station 1', [7, 8, 9])
        destination = Station.new('Extreme Station 2', [1, 2, 3])
        expect(subject.calculate_zones_travelled(origin, destination)).to eq([7, 3])
      end
    end

    context 'extra specs for coverage' do
      it 'origin station array minimum zone is greater than destination zone' do
        origin = Station.new('Station 1', [3, 4])
        destination = Station.new('Station 2', 2)
        expect(subject.calculate_zones_travelled(origin, destination)).to eq([3, 2])
      end
    end
  end
end
