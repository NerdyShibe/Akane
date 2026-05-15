# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Holds the logic of all the PUSH instructions.
        class Push < Base
          # Creates a Push instruction object with a mnemonic and logic to be executed.
          def initialize(cpu:, r16:)
            super(cpu:)

            @mnemonic = "PUSH #{format_operand(r16)}"
            @logic    = build_logic(r16)
          end

          private

          # Returns a Proc object to be executed by the CPU at runtime.
          def build_logic(r16)
            case r16
            when :bc then -> { push(@registers.bc) }
            when :de then -> { push(@registers.de) }
            when :hl then -> { push(@registers.hl) }
            when :af then -> { push(@registers.af) }
            end
          end

          # M-cycle 1: Fetches opcode.
          # M-cycle 2: Internal processing (dead cycle).
          # M-cycle 2: Writes msb from r16 into the stack.
          # M-cycle 3: Writes lsb from r16 into the stack.
          def push(r16)
            @cpu.internal_processing
            @cpu.stack_push(value: r16)
          end
        end
      end
    end
  end
end
