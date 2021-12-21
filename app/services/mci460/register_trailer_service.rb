module Mci460
  class RegisterTrailerService < ApplicationService
    def initialize(registers)
      @registers = registers
    end

    def call
      prepare_data(@registers)
    end

    private

    def prepare_data(registers)
      register_1_count = registers[:register01].count
      '9999999' <<
        register_1_count.to_s[0..4].rjust(5, '0') <<
        (register_1_count + 2).to_s[0..8].rjust(9, '0') <<
        "#{' ' * 129}\r\n"
    end
  end
end
