# frozen_string_literal: true

class DummyMenu
  include Menu

  attr_reader :scanner

  def initialize
    @scanner = Scanner.new
  end
end

RSpec.describe Menu do
  subject { DummyMenu.new }

  describe '#print_menu' do
    it 'prints a menu with just welcome messages' do
      expect do
        subject.print_menu(['Welcome', 'To the RSpec tests'])
      end.to output("Welcome\nTo the RSpec tests\n\n").to_stdout
    end

    it 'prints a menu with just selection options' do
      expect do
        subject.print_menu([], ['Option 1', 'Option 2'])
      end.to output("  1. Option 1\n  2. Option 2\n\n").to_stdout
    end

    it 'prints a menu with a welcome message and selection options' do
      expect do
        subject.print_menu(['Welcome', 'To the RSpec tests'], ['Option 1', 'Option 2'])
      end.to output("Welcome\nTo the RSpec tests\n\n  1. Option 1\n  2. Option 2\n\n").to_stdout
    end
  end

  describe '#find_card' do
    it 'prompts for a card to be entered' do
      card = Card.new
      subject.scanner.register_card(card)
      allow($stdin).to receive(:gets).and_return(card.card_number)

      expect do
        subject.find_card
      end.to output("Please scan your card\n(For this demo, please enter your card number)\n\n").to_stdout
    end

    it 'it calls the Scanner#scan and returns the resulting card' do
      card = Card.new
      subject.scanner.register_card(card)
      allow($stdin).to receive(:gets).and_return(card.card_number)

      expect(subject.scanner).to receive(:scan).with(card.card_number).and_return(card)
      subject.find_card
    end
  end

  describe '#clear_screen' do
    it "calls system('cls') and system('clear') to clear the terminal" do
      expect(subject).to receive(:system).with('cls')
      expect(subject).to receive(:system).with('clear')
      subject.clear_screen
    end
  end
end
