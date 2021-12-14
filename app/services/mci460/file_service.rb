module Mci460
  class FileService < ApplicationService
    attr_reader :registers

    def initialize(registers)
      @registers = registers
    end

    def call
      doc = ''
      doc << @registers[:header]
      doc << @registers[:register01].values.join('')
      doc << @registers[:trailer]
    end
  end
end
