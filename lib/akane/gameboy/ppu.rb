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

      attr_reader :lcdc, :stat, :scy, :scx
      attr_accessor :ly

      def initialize(interrupts)
        @interrupts = interrupts

        @vram = Ram.new(8192)
        @oam  = Ram.new(160)
        @mode = MODES[:h_blank]

        @lcdc = 0x00
        @stat = 0x00
        @scy  = 0x00
        @scx  = 0x00
        @ly   = 0x00
        @lyc  = 0x00

        @wy = 0x00
        @wx = 0x00
      end

      # Returns a 8-bit value stored in VRAM in a given offset.
      def read_vram(offset)
        return 0xFF unless @mode == MODES[:vblank]

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
        # l
      end
    end
  end
end
