# frozen_string_literal: true

RSpec.describe KioskMenu do
  before do
    allow(subject).to receive(:display_welcome)
  end

  describe '#handle_input' do
    it 'calls to register a new card if the appropriate option is selected' do
      expect(subject).to receive(:register_card)

      subject.send(:handle_input, '1')
    end

    it 'calls to top up a card if the appropriate option is selected' do
      expect(subject).to receive(:top_up_card)

      subject.send(:handle_input, '2')
    end

    it 'calls to check a card balance if the appropriate option is selected' do
      expect(subject).to receive(:check_balance)

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

  describe '#register_card' do

    let(:card) { Card.new }

    before do
      allow(subject.instance_variable_get(:@scanner)).to receive(:register_card)
      allow(subject.instance_variable_get(:@scanner)).to receive(:current_card).and_return(card)
    end

    it 'calls for a card to be created' do
      expect(Card).to receive(:new)

      subject.send(:register_card)
    end

    it 'calls for a card to be registered' do
      expect(subject.instance_variable_get(:@scanner)).to receive(:register_card)

      subject.send(:register_card)
    end

    it 'calls for the screen to be cleared' do
      expect(subject).to receive(:clear_screen)

      subject.send(:register_card)
    end

    it 'informs the user of their card number' do
      expect {subject.send(:register_card) }.to output("Card registered.\nYour card number is: #{card.card_number}\n\n").to_stdout
    end

    it 'reprints the menu' do
      expect(subject).to receive(:display_welcome)

      subject.send(:register_card)
    end
  end

  describe '#top_up_card' do

    let (:card) { Card.new }
    
    before do
      allow(card).to receive(:top_up).and_return('12.34')
      subject.instance_variable_get(:@scanner).register_card(card)
      allow($stdin).to receive(:gets).and_return('12.345')
    end

    context 'when a card has been scanned in the current session' do
      it 'reads the card from the current session' do
        expect(subject.instance_variable_get(:@scanner)).to receive(:current_card).and_return(card)

        subject.send(:top_up_card)
      end
    end

    context 'when a card has not been scanned in the current session' do
      before do
        allow(subject).to receive(:find_card).and_return(Card.new)
      end

      it 'calls #find_card' do
        subject.instance_variable_get(:@scanner).clear_card
        expect(subject).to receive(:find_card)

        subject.send(:top_up_card)
      end
    end

    it 'asks the user to enter their top-up amount' do
      expect do
        subject.send(:top_up_card)
      end.to output(/please enter how much you would like to top-up by in GBP: \n\n/i).to_stdout
    end

    it 'calls for the card to be topped up by the specified amount' do
      expect(card).to receive(:top_up).with('12.345')

      subject.send(:top_up_card)
    end

    it 'clears the screen' do
      expect(subject).to receive(:clear_screen)

      subject.send(:top_up_card)
    end

    it 'informs the user how much their card has been topped up by' do
      expect do
        subject.send(:top_up_card)
      end.to output(/card topped up by £12.34, thank you and have a safe journey.\n/i).to_stdout
    end

    it 're-renders the menu' do
      expect(subject).to receive(:display_welcome)

      subject.send(:top_up_card)
    end
  end

  describe '#check_balance' do
    let (:card) { Card.new }
    
    before do
      subject.instance_variable_get(:@scanner).register_card(card)
      allow($stdin).to receive(:gets).and_return('ok')
    end

    context 'when a card has been scanned in the current session' do
      it 'reads the card from the current session' do
        expect(subject.instance_variable_get(:@scanner)).to receive(:current_card).and_return(card)

        subject.send(:check_balance)
      end
    end

    context 'when a card has not been scanned in the current session' do
      before do
        allow(subject).to receive(:find_card).and_return(Card.new)
      end

      it 'calls #find_card' do
        subject.instance_variable_get(:@scanner).clear_card
        expect(subject).to receive(:find_card)

        subject.send(:check_balance)
      end
    end

    it 'informs the user of their current card balance' do
      expect do
        subject.send(:check_balance)
      end.to output(/your current balance is: £0.00\n\npress any key to continue.\n/i).to_stdout

      card.top_up(15)

      expect do
        subject.send(:check_balance)
      end.to output(/your current balance is: £15.00\n\npress any key to continue.\n/i).to_stdout
    end

    it 'clears the screen' do
      expect(subject).to receive(:clear_screen)

      subject.send(:check_balance)
    end

    it 're-renders the menu' do
      expect(subject).to receive(:display_welcome)

      subject.send(:check_balance)
    end
  end

  describe '#exit_menu' do
    it 'calls for the scanner to clear the card' do
      expect(subject.instance_variable_get(:@scanner)).to receive(:clear_card)

      subject.send(:exit_menu)
    end
  end
end