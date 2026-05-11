# frozen_string_literal: true

require 'debug'

module Akane
  module Gameboy
    # Models the CPU behavior from the Game Boy.
    class Cpu
      Instruction = Data.define(:mnemonic, :steps_proc) do
        def execute
          steps_proc.call
        end
      end

      include Instructions

      def initialize(bus, interrupts, advance_components)
        @bus = bus
        @interrupts = interrupts
        @advance_components = advance_components

        @registers = Registers.new
        @instructions = load_base_instructions
        @cb_instructions = load_cb_instructions
        @ime = false
        @opcode = nil
        @instruction = nil

        @m_cycles = 0
      end

      # Core CPU loop:
      #
      # - Checks IME and any interrupts pending to be serviced.
      # - Fetches the current Opcode at the Program Counter.
      # - Decodes which instruction based on the Opcode fetched.
      # - Executes the instruction.
      def run
        handle_interrupts if @ime && @interrupts.any_pending?

        old_pc = @registers.pc
        @opcode = fetch_byte
        decode_instruction
        execute_instruction
        log(old_pc, @instruction)
      end

      private

      # Checks if any interrupt is enabled and requested to service.
      def handle_interrupts
        puts 'Interrupts handled'
      end

      # Fetches the next immediate byte from memory pointed to by the Program Counter.
      def fetch_byte
        byte = bus_read(@registers.pc)
        @registers.pc += 1

        byte
      end

      # Fetches the next 2 immediate bytes from memory.
      #
      # - The Game Boy uses little endian format.
      # - This means that the first byte fetched is the least significant one.
      # - So if the memory has these next 2 bytes: $50 $01, the word is: $0150
      def fetch_word
        lower_byte = fetch_byte
        higher_byte = fetch_byte

        (higher_byte << 8) | lower_byte
      end

      def jump_to(address)
        @registers.pc = address
        internal_processing
      end

      # Determines which instruction should be executed for each Opcode.
      def decode_instruction
        @instruction = @instructions[@opcode]
        raise "Opcode not implemented yet: #{format('$%02X', @opcode)}" if @instruction.nil?
      end

      # Executes the logic for the current instruction.
      def execute_instruction
        @instruction.execute
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
        @m_cycles += 1
        @advance_components.call(t_cycles)
      end

      def log(old_pc, instruction)
        puts "#{format('%04d', @m_cycles)}    |  " \
             "#{format('$%04X', old_pc)}  |  " \
             "#{instruction.mnemonic}          |  " \
             "#{format('$%02X', @bus.read_byte(old_pc))} " \
             "#{format('$%02X', @bus.read_byte(old_pc + 1))} " \
             "#{format('$%02X', @bus.read_byte(old_pc + 2))}  |  " \
             "AF: $#{format('%04X', @registers.af)}  |  " \
             "BC: $#{format('%04X', @registers.bc)}  |  " \
             "DE: $#{format('%04X', @registers.de)}  |  " \
             "HL: $#{format('%04X', @registers.hl)}  |  "
      end
    end
  end
end
