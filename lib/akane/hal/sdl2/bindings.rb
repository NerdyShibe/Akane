# frozen_string_literal: true

require 'ffi'

module Akane
  module HAL
    # Implement all SDL2 bindings needed.
    module SDL2
      module Bindings
        extend FFI::Library

        ffi_lib 'SDL2'

        SDL_INIT_VIDEO              = 0x00000020
        SDL_WINDOWPOS_CENTERED      = 0x2FFF0000
        SDL_WINDOW_SHOWN            = 0x00000004
        SDL_PIXELFORMAT_ARGB8888    = 0x16362004
        SDL_TEXTUREACCESS_STREAMING = 1
        SDL_RENDERER_ACCELERATED    = 0x00000002
        SDL_QUIT                    = 0x100
        EVENT_SIZE                  = 56

        attach_function :Init, [:uint32], :int
        attach_function :Quit, [], :void
        attach_function :GetError, [], :string

        attach_function :CreateWindow, %i[string int int int int uint32], :pointer
        attach_function :DestroyWindow, [:pointer], :void

        attach_function :CreateRenderer, %i[pointer int uint32], :pointer
        attach_function :DestroyRenderer, [:pointer], :void

        attach_function :CreateTexture, %i[pointer uint32 int int int], :pointer
        attach_function :UpdateTexture, %i[pointer pointer pointer int], :int
        attach_function :DestroyTexture, [:pointer], :void

        attach_function :RenderCopy, %i[pointer pointer pointer pointer], :int
        attach_function :RenderPresent, [:pointer], :int

        attach_function :PollEvent, [:pointer], :int
      end
    end
  end
end
