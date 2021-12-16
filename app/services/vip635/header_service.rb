module Vip635
  class HeaderService < BaseSpreadsheetService
    attr_reader :sheet

    def initialize(sheet, remessa)
      @sheet = sheet
      @remessa = remessa
    end

    def call
      result = ''
      header_mapping = Hash[sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }]

      (2..sheet.last_row).each do |row_number|
        data = SpreadsheetUtils.prepare_data(header_mapping, sheet, row_number)
        data = normalize_values(data)
        line = prepare_data(data)

        raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

        result = "#{line}\r\n"
      end
      result
    end

    private

    def prepare_data(data)
      '0' * 7 <<
        Date.current.strftime('%d%m%Y') <<
        'VIPF635 ' <<
        data[:codigo_interno_da_empresa_no_bb][0..8].rjust(9, '0') <<
        data[:numero_do_processo][0..4].rjust(5, '0') <<
        @remessa[0..4].rjust(5, '0') <<
        '01' <<
        data[:prefixo_da_agencia_cliente][0..3].rjust(4, '0') <<
        data[:digito_verificador_da_agencia][0..0].rjust(1, '0') <<
        data[:numero_da_conta_do_cliente][0..10].rjust(11, '0') <<
        data[:digito_verificador_da_conta_corrente][0..0].rjust(1, '0') <<
        (' ' * 89).to_s
    end
  end
end
