# frozen_string_literal: true

RSpec.describe Scanner do
  describe '#register_card' do
    it 'registers a new card and adds it to the class variable array' do
      card = Card.new
      subject.register_card(card)

      expect(Scanner.class_variable_get(:@@cards).keys).to include(card.card_number)
    end

    it 'sets the registered card to be the #current_card' do
      card = Card.new
      subject.register_card(card)

      expect(subject.current_card).to eq(card)
    end

    context 'exceptions' do
      it 'raises an error if trying to register an already registered card' do
        card = Card.new
        subject.register_card(card)

        expect { subject.register_card(card) }.to raise_error(InputError, /card already registered/i)
      end
    end
  end

  describe '#clear_card' do
    it 'resets the #current_card to nil' do
      card = Card.new
      subject.register_card(card)
      subject.clear_card

      expect(subject.current_card).to eq(nil)
    end
  end

  describe '#scan' do
    it 'sets the #current_card to be the scanned card' do
      card = Card.new
      subject.register_card(card)
      subject.clear_card
      subject.scan(card.card_number)

      expect(subject.current_card).to eq(card)
    end

    context 'exceptions' do
      it 'raises an error if the card number is invalid' do
        expect { subject.scan('invalid_card_number') }.to raise_error(InputError, /unreadable card, please try again/i)
      end

      it 'raises an error if the card cannot be found' do
        expect { subject.scan(1234567890) }.to raise_error(InputError, /card not found, please try again/i)
      end
    end
  end
end
