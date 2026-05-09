# frozen_string_literal: true

module Akane
  module Gameboy
    # Models the CPU behavior from the Game Boy.
    class Cpu
      INSTRUCTIONS = {
        0x00 => -> { puts '$00 executed' },
        0x01 => -> { puts '$01 executed' }
      }.freeze

      CB_INSTRUCTIONS = {
        0x00 => -> { puts '$CB $00 executed' },
        0x01 => -> { puts '$CB $01 executed' }
      }.freeze

      def initialize(bus, interrupts, advance_components)
        @bus = bus
        @interrupts = interrupts
        @advance_components = advance_components

        @registers = Registers.new
        @ime = false
        @opcode = nil
        @instruction = nil
      end

      # Core CPU loop:
      #
      # - Checks IME and any interrupts pending to be serviced.
      # - Fetches the current Opcode at the Program Counter.
      # - Decodes which instruction based on the Opcode fetched.
      # - Executes the instruction.
      def run
        handle_interrupts if @ime && @interrupts.any_pending?

        fetch_opcode
        decode_opcode
        execute_instruction
      end

      private

      # Checks if any interrupt is enabled and requested to service.
      def handle_interrupts
        puts 'Interrupts handled'
      end

      # Special read that gets the byte pointed to by the Program Counter.
      def fetch_opcode
        @opcode = bus_read(@registers.pc)
        @registers.pc += 1
      end

      # Determines which instruction should be executed for each Opcode.
      def decode_opcode
        @instruction = INSTRUCTIONS[@opcode]
      end

      # Executes the logic for the current instruction.
      def execute_instruction
        @instruction.call
      rescue NoMethodError
        puts "Opcode not implemented yet: #{@opcode}"
      end

      # Reads a byte from the Bus at a given address.
      def bus_read(address)
        byte = @bus.read_byte(address)
        advance_cycles(4)

        byte
      end

      # Requests a Bus write at a given address with a given value.
      def bus_write(address, value)
        @bus.write_byte(address, value)
        advance_cycles(4)
      end

      # Emulates CPU internal processing which advance cycles without Bus access.
      def internal_processing
        advance_cycles(4)
      end

      # Syncs all components after each M-cycle.
      def advance_cycles(t_cycles)
        @advance_components.call(t_cycles)
      end
    end
  end
end
