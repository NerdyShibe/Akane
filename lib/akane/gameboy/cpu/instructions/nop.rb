# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Defines the mnemonic, bytes and logic for the NOP instruction.
        class Nop < Base
          def initialize(cpu:)
            super

            @mnemonic = 'NOP'
            @bytes = 1
            @m_cycles = 1
            @logic = -> {}
          end
        end
      end
    end
  end
end
