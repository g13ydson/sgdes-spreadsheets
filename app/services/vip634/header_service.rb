module Vip634
  class HeaderService < BaseSpreadsheetService
    attr_reader :sheet, :remessa

    def initialize(sheet, remessa)
      @sheet = sheet
      @remessa = remessa
    end

    def call
      result = ""
      header_mapping = sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }.to_h

      (2..sheet.last_row).each do |row_number|
        data = SpreadsheetUtils.prepare_data(header_mapping, sheet, row_number)
        data = normalize_values(data)
        line = prepare_data(data)

        raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

        result = "#{line}\n"
      end
      result
    end

    private

    def prepare_data(data)
      "0" * 7 <<
        Date.current.strftime("%d%m%Y") <<
        "MCIF460 " <<
        data[:codigo_mci_do_cliente_no_banco][0..8].rjust(9, "0") <<
        data[:numero_do_processo][0..4].rjust(5, "0") <<
        remessa[0..4].rjust(5, "0") <<
        "04" <<
        data[:prefixo_da_agencia_de_relacionamento][0..3].rjust(4, "0") <<
        data[:digito_verificador_da_agencia_de_relacionamento][0..0].rjust(1, "0") <<
        data[:numero_da_conta_do_cliente][0..10].rjust(11, "0") <<
        data[:digito_verificador_da_conta_do_cliente][0..0].rjust(1, "0") <<
        "1" <<
        (" " * 88).to_s
    end
  end
end
