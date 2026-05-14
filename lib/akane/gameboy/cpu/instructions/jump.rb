# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Holds the logic of all the load instructions.
        class Jump < Base
          def initialize(cpu:, location:)
            super(cpu:)

            @mnemonic = define_mnemonic(location)
            @bytes    = define_bytes(location)
            @m_cycles = define_m_cycles(location)
            @logic    = define_logic(location)
          end

          private

          def define_mnemonic(location)
            case location
            when :imm16 then 'JP n16'
            end
          end

          def define_bytes(location)
            case location
            when :imm16 then 3
            end
          end

          def define_m_cycles(location)
            case location
            when :imm16 then 4
            end
          end

          def define_logic(location)
            case location
            when :imm16 then -> { @cpu.jump_to(address: @cpu.fetch_next_word) }
            end
          end
        end
      end
    end
  end
end
