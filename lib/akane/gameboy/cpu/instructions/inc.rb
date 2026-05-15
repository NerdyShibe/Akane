# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Holds the logic of all the INC (Increment) instructions.
        class Inc < Base
          def initialize(cpu:, operand:)
            super(cpu:)

            @mnemonic = "INC #{format_operand(operand)}"
            @bytes    = 1 + fetch_cost(operand)
            @m_cycles = 1 + memory_cost(operand)
            @logic    = define_logic(operand)
          end

          private

          def define_logic(operand)
            case operand
            when :a      then -> { @registers.a = inc(@registers.a) }
            when :b      then -> { @registers.b = inc(@registers.b) }
            when :c      then -> { @registers.c = inc(@registers.c) }
            when :d      then -> { @registers.d = inc(@registers.d) }
            when :e      then -> { @registers.e = inc(@registers.e) }
            when :h      then -> { @registers.h = inc(@registers.h) }
            when :l      then -> { @registers.l = inc(@registers.l) }
            when :mem_hl
              lambda {
                value_at_mem_hl = @cpu.bus_read(address: @registers.hl)
                @cpu.bus_write(address: @registers.hl, value: inc(value_at_mem_hl))
              }
            end
          end

          def inc(value)
            result = value + 1

            @registers.z_flag = result.zero?
            @registers.n_flag = false
            @registers.h_flag = value.allbits?(0x0F)

            result
          end
        end
      end
    end
  end
end
