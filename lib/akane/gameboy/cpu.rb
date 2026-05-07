# frozen_string_literal: true

module Akane
  module Gameboy
    # Models the CPU behavior from the Game Boy.
    class Cpu
      def initialize
        @registers = Cpu::Registers.new
        @ime = false
      end
    end
  end
end
