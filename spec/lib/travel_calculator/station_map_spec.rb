# frozen_string_literal: true

RSpec.describe StationMap do

  before do
    StationMap.build_map
  end

  describe '#build_map' do
    it 'builds a hash of stations from an imported csv' do
      # It's difficult to test equality of full hash as values are objects, so the references change.
      # It is of course possible to test each field, but for this case I thought the keys sufficed.
      expect(StationMap.class_variable_get(:@@stations).keys.sort).to eq(['holborn', "earl's court", 'hammersmith', 'wimbledon'].sort)
    end
  end

  describe '#get_station' do
    it 'fetches a station based on the station name' do
      station = StationMap.get_station('Wimbledon')
      expect(station.name).to eq('Wimbledon')
      expect(station.zones).to eq(3)
    end

    it 'raises an error if it cannot find the station' do
      expect { StationMap.get_station('Not a real station') }.to raise_error(InputError, /station not found, please try again/i)
      expect { StationMap.get_station(6) }.to raise_error(InputError, /station not found, please try again/i)
      expect { StationMap.get_station(Object.new) }.to raise_error(InputError, /station not found, please try again/i)

    end
  end
end