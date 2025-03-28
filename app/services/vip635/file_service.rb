module Vip635
  class FileService < ApplicationService
    attr_reader :registers

    def initialize(registers)
      @registers = registers
    end

    def call
      doc = ""
      doc << registers[:header]
      doc << registers[:register01].merge!(registers[:register06], registers[:register07],
        registers[:register11], registers[:register12]) do |_key, o, n|
        o + n
      end.values.join("")

      doc << registers[:trailer]
    end
  end
end
