# frozen_string_literal: true

module Akane
  # Handles the core emulation loop.
  class Emulator
    def self.start(file_path)
      puts "Emulator started with #{file_path}"
      Akane::Cartridge.load_rom(file_path)
    end
  end
end
