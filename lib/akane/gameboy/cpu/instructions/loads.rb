# frozen_string_literal: true

module Akane
  module Gameboy
    class Cpu
      module Instructions
        # Holds the logic of all the load instructions.
        module Loads
          private

          # Loads the value of A into A. Essentially a No-op.
          def ld_a_a; end

          # Loads the value of B into A.
          def ld_a_b
            @registers.a = @registers.b
          end

          # Loads the value of C into A.
          def ld_a_c
            @registers.a = @registers.c
          end

          # Loads the value of D into A.
          def ld_a_d
            @registers.a = @registers.d
          end

          # Loads the value of E into A.
          def ld_a_e
            @registers.a = @registers.e
          end

          # Loads the value of H into A.
          def ld_a_h
            @registers.a = @registers.h
          end

          # Loads the value of L into A.
          def ld_a_l
            @registers.a = @registers.l
          end

          # Loads the value at address HL into A.
          def ld_a_hl
            @registers.a = bus_read(@registers.hl)
          end

          # Loads the value of A into B.
          def ld_b_a
            @registers.a = @registers.b
          end

          # Loads the value of B into B. Essentially a No-op.
          def ld_b_b; end

          # Loads the value of C into B.
          def ld_b_c
            @registers.b = @registers.c
          end

          # Loads the value of D into B.
          def ld_b_d
            @registers.b = @registers.d
          end

          # Loads the value of E into B.
          def ld_b_e
            @registers.b = @registers.e
          end

          # Loads the value of H into B.
          def ld_b_h
            @registers.b = @registers.h
          end

          # Loads the value of L into B.
          def ld_b_l
            @registers.b = @registers.l
          end

          # Loads the value at address HL into B.
          def ld_b_hl
            @registers.b = bus_read(@registers.hl)
          end
        end
      end
    end
  end
end
