# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Handles the logic related to all possible XOR instructions
        #
        # - XOR A, r8
        # - XOR A, [HL]
        # - XOR A, n8
        class Xor < Base
          # @param cpu [Cpu] Holds a direct reference to the main Cpu object.
          # @param source [Symbol] Operator, can be a register, :mem_hl, :imm8.
          def initialize(cpu:, source:)
            super(cpu:)

            @mnemonic = define_mnemonic(source)
            @bytes    = define_bytes(source)
            @m_cycles = define_m_cycles(source)
            @logic    = define_logic(source)
          end

          # Interface for the CPU to execute the logic.
          def execute
            @logic.call
          end

          private

          def define_mnemonic(source)
            case source
            when :mem_hl then 'XOR A, [HL]'
            when :imm8 then 'XOR A, n8'
            else "XOR A, #{source.upcase}"
            end
          end

          def define_bytes(source)
            source == :imm8 ? 2 : 1
          end

          def define_m_cycles(source)
            %i[imm8 mem_hl].include?(source) ? 2 : 1
          end

          def define_logic(source)
            case source
            when :a      then -> { xor_a(@registers.a) }
            when :b      then -> { xor_a(@registers.b) }
            when :c      then -> { xor_a(@registers.c) }
            when :d      then -> { xor_a(@registers.d) }
            when :e      then -> { xor_a(@registers.e) }
            when :h      then -> { xor_a(@registers.h) }
            when :l      then -> { xor_a(@registers.l) }
            when :mem_hl then -> { xor_a(@cpu.bus_read(@registers.hl)) }
            when :imm8   then -> { xor_a(@cpu.fetch_next_byte) }
            end
          end

          def xor_a(value)
            result = @registers.a ^ value

            @registers.clear_flags
            @registers.z_flag = 1 if result.zero?

            @registers.a = result
          end
        end
      end
    end
  end
end
