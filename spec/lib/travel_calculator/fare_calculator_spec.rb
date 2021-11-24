# frozen_string_literal: true

RSpec.describe FareCalculator do
  describe '#default_charge' do
    it 'charges a given card by the maximum fare' do
      card = Card.new
      subject.default_charge(card)
      expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares).values.max)
    end

    context 'exceptions' do
      it "raises an error and doesn't charge the card if the card balance is already negative" do
        card = Card.new
        card.charge(5)
        expect do
          subject.default_charge(card)
        end.to raise_error(InputError, /you need to top up your card before you can travel/i)
        expect(card.balance).to eq(-5)
      end
    end

    describe '#calculate_fare' do
      context 'for bus travel' do
        it 'charges the correct fare' do
          card = Card.new
          subject.calculate_fare(card, 'bus')
          expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:bus])
        end

        context 'exceptions' do
          it "raises an error and doesn't charge the card if the card balance is already negative" do
            card = Card.new
            card.charge(5)
            expect do
              subject.calculate_fare(card, 'bus')
            end.to raise_error(InputError, /you need to top up your card before you can travel/i)
            expect(card.balance).to eq(-5)
          end
        end
      end

      context 'for tube travel' do
        context 'when travel includes zone 1' do
          it 'charges the correct amount for a single-zone trip' do
            card = Card.new
            subject.default_charge(card)
            subject.calculate_fare(card, 'tube', Station.new('station 1', 1), Station.new('station 2', 1))
            expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:zone1])
          end

          it 'charges the correct amount for a two-zone trip' do
            card = Card.new
            subject.default_charge(card)
            subject.calculate_fare(card, 'tube', Station.new('station 1', 1), Station.new('station 2', 2))
            expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:two_zones_inc_z1])
          end

          it 'charges the correct amount for a three-zone trip' do
            card = Card.new
            subject.default_charge(card)
            subject.calculate_fare(card, 'tube', Station.new('station 1', 3), Station.new('station 2', 1))
            expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:three_zones])
          end
        end

        context 'when travel excludes zone 1' do
          it 'charges the correct amount for a single-zone trip' do
            card = Card.new
            subject.default_charge(card)
            subject.calculate_fare(card, 'tube', Station.new('station 1', 2), Station.new('station 2', 2))
            expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:one_zone_excl_z1])
          end

          it 'charges the correct amount for a two-zone trip' do
            card = Card.new
            subject.default_charge(card)
            subject.calculate_fare(card, 'tube', Station.new('station 1', 3), Station.new('station 2', 2))
            expect(card.balance).to eq(0 - FareCalculator.class_variable_get(:@@fares)[:two_zones_excl_z1])
          end
        end

        context 'exceptions' do
          it 'raises an error if the origin is missing' do
            card = Card.new
            expect do
              subject.calculate_fare(card, 'tube', nil, Station.new('station', 1))
            end.to raise_error(InputError, /you need to enter an origin and destination/i)
          end

          it 'raises an error if the destination is missing' do
            card = Card.new
            expect do
              subject.calculate_fare(card, 'tube', Station.new('station', 1))
            end.to raise_error(InputError, /you need to enter an origin and destination/i)
          end

          it 'raises an error if both the origin and destination are missing' do
            card = Card.new
            expect do
              subject.calculate_fare(card, 'tube')
            end.to raise_error(InputError, /you need to enter an origin and destination/i)
          end
        end
      end
    end
  end
end
