# frozen_string_literal: true

module Akane
  # Models a Game Boy cartridge.
  class Cartridge
    def initialize(rom_path)
      @rom = Akane::Cartridge::Rom.new(rom_path)

      puts "Rom Title: #{@rom.title}"
    end
  end
end
