# frozen_string_literal: true

describe Akane::Gameboy::Bus do
  subject(:bus) { described_class.new }

  describe '#initialize' do
    it 'initializes the bus' do
      expect(bus).not_to be_nil
    end
  end
end
