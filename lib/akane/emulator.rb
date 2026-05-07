# frozen_string_literal: true

module Akane
  # Handles the core emulation loop.
  class Emulator
    def self.start(rom_path)
      puts "Emulator started with #{rom_path}"
      Akane::Cartridge.new(rom_path)
    end
  end
end
