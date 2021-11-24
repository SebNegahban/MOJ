# frozen_string_literal: true

RSpec.describe Foyer do
  subject { Foyer.new }

  context '#initialze' do
    it 'calls builds the station map' do
      expect(StationMap).to receive(:build_map)

      Foyer.new
    end
  end

  context '#handle_input' do
    before do
      allow(subject).to receive(:display_welcome)
    end

    it 'builds a kiosk menu when the appropriate option is selected' do
      expect_any_instance_of(KioskMenu).to receive(:display_welcome)
      subject.send(:handle_input, '1')
    end

    it 'builds a journey menu when the appropriate option is selected' do
      expect_any_instance_of(JourneyMenu).to receive(:display_welcome)
      subject.send(:handle_input, '2')
    end

    it 'exits when the appropriate option is selected' do
      expect { subject.send(:handle_input, '3') }.to raise_error(SystemExit)
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
end
