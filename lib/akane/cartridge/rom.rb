# frozen_string_literal: true

module Akane
  class Cartridge
    # models the ROM inside the Game Boy cartridge.
    class Rom
      def initialize(rom_path)
        @data = File.binread(rom_path)
      end

      def header
        @data[0x0100..0x014F]
      end

      def title
        @data[0x0134..0x0143]
      end

      def manufacturer_code
        @data[0x013F..0x0142]
      end

      def cgb_flag
        @data[0x0143]
      end

      def new_licensee_code
        @data[0x0144..0x0145]
      end

      def sgb_flag
        @data[0x0146]
      end

      def cartridge_type
        @data[0x0147]
      end

      def rom_size
        @data[0x0148]
      end

      def ram_size
        @data[0x0149]
      end

      def destination_code
        @data[0x014A]
      end

      def old_licensee_code
        @data[0x014B]
      end

      def mask_rom_version
        @data[0x014C]
      end
    end
  end
end
