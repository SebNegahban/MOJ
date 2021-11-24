# frozen_string_literal: true

RSpec.describe JourneyMenu do
  let(:card) { Card.new }

  before do
    allow(subject).to receive(:find_card).and_return(card)
    allow(subject).to receive(:display_welcome)
  end

  describe '#handle_input' do
    it 'fetches the origin station if the appropriate option is selected' do
      expect(subject).to receive(:fetch_origin)

      subject.send(:handle_input, '1')
    end

    it 'fetches the destination station if the appropriate option is selected' do
      expect(subject).to receive(:fetch_destination)

      subject.send(:handle_input, '2')
    end

    it 'triggers bus travel if the appropriate option is selected' do
      expect(subject).to receive(:take_bus)

      subject.send(:handle_input, '3')
    end

    it 'triggers the exit of the menu if the appropriate option is selected' do
      expect(subject).to receive(:exit_menu)

      subject.send(:handle_input, '4')
    end

    it 'outputs a message if an invalid option is selected' do
      expect do
        subject.send(:handle_input, 'test')
      end.to output(/invalid selection, please try again.\n\n/i).to_stdout
    end

    it 'reprints the menu if an invalid option is selected' do
      expect(subject).to receive(:display_welcome)

      subject.send(:handle_input, 'test')
    end
  end

  describe '#fetch_origin' do
    before do
      allow(subject).to receive(:find_station).and_return(Station.new('test', 1))
    end

    it 'calls for the station to be entered' do
      expect(subject).to receive(:find_station)

      subject.send(:fetch_origin)
    end

    it 'calls for the card to be entered' do
      expect(subject).to receive(:find_card)

      subject.send(:fetch_origin)
    end

    it "calls for the user's card to be charged by the default amount" do
      expect_any_instance_of(FareCalculator).to receive(:default_charge).with(card)

      subject.send(:fetch_origin)
    end

    it 'clears the origin station if an error is raised when attempting to find the card' do
      allow(subject).to receive(:find_card).and_raise(InputError)

      expect { subject.send(:fetch_origin) }.to raise_error(InputError)
      expect(subject.instance_variable_get(:@origin)).to eq(nil)
    end

    it 'clears the origin station if an error is raised when attempting to go on a journey' do
      allow(subject.instance_variable_get(:@fare_calculator)).to receive(:default_charge).and_raise(InputError)

      expect { subject.send(:fetch_origin) }.to raise_error(InputError)
      expect(subject.instance_variable_get(:@origin)).to eq(nil)
    end

    it 're-renders the menu' do
      expect(subject).to receive(:display_welcome)

      subject.send(:fetch_origin)
    end
  end

  describe '#fetch_destination' do
    before do
      subject.instance_variable_set(:@origin, Station.new('test', 1))
      allow(subject).to receive(:find_station).and_return(Station.new('test_2', 2))
    end

    it 'calls for the station to be entered' do
      allow_any_instance_of(FareCalculator).to receive(:calculate_fare)
      expect(subject).to receive(:find_station)

      subject.send(:fetch_destination)
    end

    it 'calls for the card to be entered' do
      allow_any_instance_of(FareCalculator).to receive(:calculate_fare)
      expect(subject).to receive(:find_card)

      subject.send(:fetch_destination)
    end

    # Had to change the call order to 'expect .to have_received' here as the 'fetch_destination' method sets the
    # @destination instance var, but as the expectation would generate first (if using expect .to_receive),
    # @destination was still 'nil' at this point, causing the spec to fail (when behaviour is correct).
    it 'calls for the fare to be calculated' do
      allow(subject.instance_variable_get(:@fare_calculator)).to receive(:calculate_fare).with(any_args)
      subject.send(:fetch_destination)

      expect(subject.instance_variable_get(:@fare_calculator))
        .to have_received(:calculate_fare)
        .with(card, 'tube', subject.instance_variable_get(:@origin), subject.instance_variable_get(:@destination))
    end

    context 'exceptions' do
      it 'raises an error if the origin station has not been defined' do
        subject.instance_eval { @origin = nil }
        expect do
          subject.send(:fetch_destination)
        end.to raise_error(InputError, /you must select an origin before selecting a destination/i)
      end
    end
  end

  describe '#take_bus' do
    it 'triggers the call for the card to be entered' do
      expect(subject).to receive(:find_card)

      subject.send(:take_bus)
    end

    it 'calls for the card to be charged the bus fare' do
      expect(subject.instance_variable_get(:@fare_calculator)).to receive(:calculate_fare).with(card, 'bus')

      subject.send(:take_bus)
    end

    it 're-renders the menu' do
      expect(subject).to receive(:display_welcome)

      subject.send(:take_bus)
    end
  end

  describe '#find_station' do
    let(:station_name) { 'test' }

    before do
      allow($stdin).to receive(:gets).and_return(station_name)
      allow(StationMap).to receive(:find_station)
    end

    it 'prompts the user to enter the name of the station' do
      expect { subject.send(:find_station) }.to output(/please enter the name of the station: \n\n/i).to_stdout
    end

    it 'clears the screen' do
      expect(subject).to receive(:clear_screen)

      subject.send(:find_station)
    end

    it 'calls the StationMap to find the station' do
      expect(StationMap).to receive(:find_station).with(station_name)

      subject.send(:find_station)
    end
  end

  describe '#exit_menu' do
    it 'calls for the scanner to clear the card' do
      expect(subject.instance_variable_get(:@scanner)).to receive(:clear_card)

      subject.send(:exit_menu)
    end
  end
end
