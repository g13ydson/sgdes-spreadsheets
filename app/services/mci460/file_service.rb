module Mci460
  class FileService < ApplicationService
    attr_reader :registers

    def initialize(registers, file_name)
      @registers = registers
      @file_name = file_name
    end

    def call
      doc = ''
      doc << @registers[:header]
      doc << @registers[:register01].values.join('')
      doc << @registers[:trailer]
    end
  end
end
