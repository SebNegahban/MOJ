# frozen_string_literal: true

RSpec.describe Card do
  it 'sets a random card number on initialisation' do
    card2 = Card.new

    expect(subject.card_number.to_i).to be_between(1, 100000)

    # There is obviously a tiny chance that the two card numbers will be the same.
    # While this is miniscule, to fix it, I would utilise the MySQL database that I have previously mentioned
    # and enforce uniqueness on card numbers.
    expect(subject.card_number).not_to eq(card2.card_number)
  end

  describe '#top_up' do
    it 'adds funds to the card' do
      subject.top_up(30)

      expect(subject.balance).to eq(30)
    end

    context 'when the entered amount of funds is not in the XX.XX format' do
      it 'rounds numbers with more than 2 decimal places down to 2dp' do
        expect(subject.top_up(30.6789)).to eq(30.67)

        expect(subject.balance).to eq(30.67)
      end

      it 'takes in and returns a non-number input as 0' do
        expect(subject.top_up('NaN')).to eq(0)

        expect(subject.balance).to eq(0)
      end

      it 'raises an exception if the entered amount is negative' do
        expect { subject.top_up(-1.23) }.to raise_error(InputError, /entered amount cannot be negative/i)
      end
    end
  end

  describe '#charge' do
    it 'removes the appropriate funds from the card balance' do
      subject.top_up(10)
      subject.charge(3.5)

      expect(subject.balance).to eq(6.5)
    end

    # Going into negative balance allows a single trip to be made with insufficient funds
    it 'does allow the card to go into negative balance' do
      subject.charge(1.5)

      expect(subject.balance).to eq(-1.5)
    end

    context 'exceptions' do
      it 'raises an exception if the charged amount is negative' do
        expect { subject.charge(-1.5) }.to raise_error(InputError, /entered amount cannot be negative/i)
      end
    end
  end

  describe '#refund' do
    it 'calls #top_up' do
      expect(subject).to receive(:top_up).with(10)
      subject.refund(10)
    end
  end
end
