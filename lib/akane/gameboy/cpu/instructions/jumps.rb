# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Holds the logic of all the load instructions.
        module Jumps
          private

          # Fetches the next 2 bytes in memory and jumps to it.
          def jump_imm16
            address = fetch_word
            jump_to(address)
          end
        end
      end
    end
  end
end
