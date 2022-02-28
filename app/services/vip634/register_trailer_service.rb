module Vip634
  class RegisterTrailerService < ApplicationService
    attr_reader :registers

    def initialize(registers)
      @registers = registers
    end

    def call
      prepare_data
    end

    private

    def prepare_data
      register_1_count = registers[:register01].count
      "9999999" <<
        register_1_count.to_s[0..4].rjust(5, "0") <<
        (register_1_count + 2).to_s[0..8].rjust(9, "0") <<
        "#{" " * 129}\n"
    end
  end
end
