# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Handles the logic for the HALT instruction.
        class Halt < Base
          def initialize(cpu:)
            super

            @mnemonic = 'HALT'
            @logic    = -> { @cpu.halt }
          end
        end
      end
    end
  end
end
