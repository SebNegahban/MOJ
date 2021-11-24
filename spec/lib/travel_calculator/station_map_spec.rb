# frozen_string_literal: true

RSpec.describe StationMap do
  before do
    StationMap.build_map
  end

  describe '#build_map' do
    it 'builds a hash of stations from an imported csv' do
      # It's difficult to test equality of full hash as values are objects, so the references change.
      # It is of course possible to test each field, but for this case I thought the keys sufficed.

      # rubocop:disable Layout/LineLength
      # I can't find a way to break this line up that doesn't make it look like a complete mess
      expect(StationMap.class_variable_get(:@@stations).keys.sort).to eq(['holborn', "earl's court", 'hammersmith', 'wimbledon'].sort)
      # rubocop:enable Layout/LineLength
    end
  end

  describe '#find_station' do
    it 'fetches a station based on the station name' do
      station = StationMap.find_station('Wimbledon')
      expect(station.name).to eq('Wimbledon')
      expect(station.zones).to eq(3)
    end

    it 'raises an error if it cannot find the station' do
      expect do
        StationMap.find_station('Not a real station')
      end.to raise_error(InputError, /station not found, please try again/i)
      expect { StationMap.find_station(6) }.to raise_error(InputError, /station not found, please try again/i)
      expect { StationMap.find_station(Object.new) }.to raise_error(InputError, /station not found, please try again/i)
    end
  end
end
