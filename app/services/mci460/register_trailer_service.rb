module Mci460
  class RegisterTrailerService < BaseSpreadsheetService
    attr_reader :sheet

    def initialize(registers)
      @registers = registers
    end

    def call
      prepare_data(@registers)
    end

    private

    def prepare_data(registers)
      '9999999' <<
        registers[:register01].count.to_s[0..4].rjust(5, '0') <<
        (registers.map { |k, v| v.size if k != :header }.compact.reduce(:+) + 2).to_s[0..8].rjust(9, '0') <<
        "#{' ' * 129}\r\n"
    end
  end
end
