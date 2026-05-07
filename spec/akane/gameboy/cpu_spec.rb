# frozen_string_literal: true

describe Akane::Gameboy::Cpu do
  subject(:cpu) { described_class.new }

  let(:registers) { Akane::Gameboy::Cpu::Registers.new }

  describe '#initialize' do
    it 'initializes the cpu' do
      expect(cpu).not_to be_nil
    end
  end
end
