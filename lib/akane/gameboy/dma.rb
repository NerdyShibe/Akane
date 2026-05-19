# frozen_string_literal: true

module Akane
  module Gameboy
    # Models the RAM chip within the Game Boy.
    #
    # On the real Game Boy, the CPU and DMA share the same physical bus.
    # During DMA, the DMA controller physically takes over the bus lines — the CPU is
    # electrically disconnected from the bus (except HRAM, which is on a separate internal path).
    # Both are clocked by the same 4MHz crystal, and each
    class DMA
      OAM_START_ADDRESS = 0xFE00
      DMA_TOTAL_CYCLES = 160

      # Receiving value 0xC0
      def initialize(trace_dma: false)
        @trace_dma = trace_dma

        @source_address = nil
        @target_address = OAM_START_ADDRESS
        @active = false
        @dma_delay = false
        @cycles = 1
      end

      # This method is called once per M-cycle, Cpu drives this.
      #
      # - DMA uses the bus to transfer one byte
      # - CPU can still execute from HRAM (it doesn't need the bus for that)
      def tick
        return unless @active
        return if @dma_delay

        @dma_delay = false

        log_initial_state if @cycles == 1 && @trace_dma

        source_byte = bus_read(address: @source_address)
        bus_write(address: @target_address, value: source_byte)

        @source_address += 1
        @target_address += 1
        @cycles += 1

        log_state if @trace_dma

        if @cycles == DMA_TOTAL_CYCLES
          @active = false
          @cycles = 1
        end
      end

      def start_transfer(bus:, source_value:)
        @bus = bus
        @active = true
        @dma_delay = true
        @source_address = (source_value << 8) | 0x00
      end

      def bus_read(address:)
        @bus.read_byte(address:)
      end

      def bus_write(address:, value:)
        @bus.write_byte(address:, value:)
      end

      def log_initial_state
        $stdout.printf(
          "DMA: #%<n>03d || $%<sa>04X -> $%<ta>04X\n",
          n: @cycles,
          sa: @source_address,
          ta: @target_address
        )
      end

      def log_state
        $stdout.printf(
          "DMA: #%<n>03d || $%<sa>04X -> $%<ta>04X\n",
          n: @cycles,
          sa: @source_address,
          ta: @target_address
        )
      end
    end
  end
end
