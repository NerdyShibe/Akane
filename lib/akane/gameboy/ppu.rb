# frozen_string_literal: true

module Akane
  module Gameboy
    # This class models the Pixel Processing Unit from the Original Game Boy.
    #
    # The PPU outputs a 160x144 pixel framebuffer each frame.
    # This framebuffer will be used by the rendered to display the graphics.
    # The PPU should not care about how the pixels are rendered, just output them.
    #
    # Specifications:
    # - The frame consists of 154 scanlines, 144 visible + 10 vblank (Cpu can access VRAM).
    # - Scanlines are drawn from top to bottom, left to right.
    # - Updating registers mid-frame can cause effects since the pixels are still being drawn.
    # - Dots per scanline = 456 t-cycles (114 m-cycles) -> Hardware spec.
    # - Dots per frame = 154 * 456 = 70_224 t-cycles (17_556 m-cycles).
    # - OAM search takes 80 dots (20 m-cycles) -> 40 sprites, 2 dots each.
    class Ppu
      MODES = {
        h_blank: 0,
        v_blank: 1,
        drawing: 2,
        oam_search: 3
      }.freeze

      DOTS_PER_SCANLINE = 456

      attr_writer :stat
      attr_accessor :lcdc, :scy, :scx, :ly, :lyc, :dma, :bgp, :obp0, :obp1, :wy, :wx

      def initialize(interrupts, trace_ppu)
        @interrupts = interrupts
        @trace_ppu = trace_ppu

        @vram = Ram.new(8192)
        @oam  = Ram.new(160)
        @mode = MODES[:oam_search]
        @dots = 0

        @lcdc = 0x00
        @stat = 0x00
        @scy  = 0x00
        @scx  = 0x00
        @ly   = 0x00
        @lyc  = 0x00
        @dma  = 0x00
        @bgp  = 0x00
        @obp0 = 0x00
        @obp1 = 0x00
        @wy   = 0x00
        @wx   = 0x00
      end

      # Reports current mode (2 bits).
      def stat
        @mode
      end

      # Returns a 8-bit value stored in VRAM in a given offset.
      #
      # VRAM data:
      # $8000-$97FF: Tile data (up to 384 tiles × 16 bytes each)
      # $9800-$9BFF: Tile map 0 (32×32 = 1024 tile indices)
      # $9C00-$9FFF: Tile map 1 (alternative map)
      def read_vram(offset)
        return 0xFF unless @mode == MODES[:v_blank]

        @vram.read_byte(offset)
      end

      # Stores a 8-bit value in VRAM in a given offset.
      def write_vram(offset, value)
        @vram.write_byte(offset, value)
      end

      # Returns a 8-bit value stored in OAM in a given offset.
      def read_oam(offset)
        @oam.read_byte(offset)
      end

      # Stores a 8-bit value in OAM in a given offset.
      def write_oam(offset, value)
        @oam.write_byte(offset, value)
      end

      def tick
        @dots = (@dots + 4) % 456
        @ly = (@ly + 1) % 154 if @dots.zero?

        if @ly >= 144
          @mode = MODES[:v_blank]
          @interrupts.request(:v_blank)
        else
          if @dots <= 79
            @mode = MODES[:oam_search]
          elsif @dots <= 251
            @mode = MODES[:drawing]
          elsif @dots <= 455
            @mode = MODES[:h_blank]
          end
        end

        trace
      end

      private

      def trace
        return unless @trace_ppu

        $stdout.printf(
          "Dots: %<dots>04d | Mode: %<mode>s | LY: $%<ly>02X (%<ly>d)\n",
          dots: @dots,
          mode: MODES.key(@mode).upcase,
          ly: @ly
        )
      end
    end
  end
end
