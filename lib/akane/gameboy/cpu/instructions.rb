# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      # Responsible to group all instruction types and load the CPU instructions array.
      module Instructions
        include Jumps
        include Loads

        private

        def load_base_instructions # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          instructions = Array.new(256)

          # Opcodes 0x00 - 0x0F
          instructions[0x00] = Instruction.new(mnemonic: 'NOP', steps_proc: -> {})

          instructions[0x3E] = Instruction.new(mnemonic: 'LD A, n8', steps_proc: -> { ld_a_n8 })

          instructions[0x40] = Instruction.new(mnemonic: 'LD B, B', steps_proc: -> { ld_b_b })
          instructions[0x41] = Instruction.new(mnemonic: 'LD B, C', steps_proc: -> { ld_b_c })
          instructions[0x42] = Instruction.new(mnemonic: 'LD B, D', steps_proc: -> { ld_b_d })
          instructions[0x43] = Instruction.new(mnemonic: 'LD B, E', steps_proc: -> { ld_b_e })
          instructions[0x44] = Instruction.new(mnemonic: 'LD B, H', steps_proc: -> { ld_b_h })
          instructions[0x45] = Instruction.new(mnemonic: 'LD B, L', steps_proc: -> { ld_b_l })

          instructions[0x50] = Instruction.new(mnemonic: 'LD D, B', steps_proc: -> { ld_d_b })
          instructions[0x51] = Instruction.new(mnemonic: 'LD D, C', steps_proc: -> { ld_d_c })
          instructions[0x52] = Instruction.new(mnemonic: 'LD D, D', steps_proc: -> { ld_d_d })
          instructions[0x53] = Instruction.new(mnemonic: 'LD D, E', steps_proc: -> { ld_d_e })
          instructions[0x54] = Instruction.new(mnemonic: 'LD D, H', steps_proc: -> { ld_d_h })
          instructions[0x55] = Instruction.new(mnemonic: 'LD D, L', steps_proc: -> { ld_d_l })

          instructions[0x60] = Instruction.new(mnemonic: 'LD H, B', steps_proc: -> { ld_h_b })
          instructions[0x61] = Instruction.new(mnemonic: 'LD H, C', steps_proc: -> { ld_h_c })
          instructions[0x62] = Instruction.new(mnemonic: 'LD H, D', steps_proc: -> { ld_h_d })
          instructions[0x63] = Instruction.new(mnemonic: 'LD H, E', steps_proc: -> { ld_h_e })
          instructions[0x64] = Instruction.new(mnemonic: 'LD H, H', steps_proc: -> { ld_h_h })
          instructions[0x65] = Instruction.new(mnemonic: 'LD H, L', steps_proc: -> { ld_h_l })

          instructions[0x70] = Instruction.new(mnemonic: 'LD [HL], B', steps_proc: -> { ld_hl_b })
          instructions[0x71] = Instruction.new(mnemonic: 'LD [HL], C', steps_proc: -> { ld_hl_c })
          instructions[0x72] = Instruction.new(mnemonic: 'LD [HL], D', steps_proc: -> { ld_hl_d })
          instructions[0x73] = Instruction.new(mnemonic: 'LD [HL], E', steps_proc: -> { ld_hl_e })
          instructions[0x74] = Instruction.new(mnemonic: 'LD [HL], H', steps_proc: -> { ld_hl_h })
          instructions[0x75] = Instruction.new(mnemonic: 'LD [HL], L', steps_proc: -> { ld_hl_l })

          instructions[0xC3] = Instruction.new(mnemonic: 'JP a16', steps_proc: -> { jump_imm16 })

          instructions.freeze
        end

        def load_cb_instructions
          cb_instructions = Array.new(256)
          cb_instructions.freeze
        end
      end
    end
  end
end
