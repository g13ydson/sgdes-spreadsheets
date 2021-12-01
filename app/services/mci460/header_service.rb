module Mci460
  class HeaderService < BaseSpreadsheetService
    attr_reader :sheet

    def initialize(sheet, remessa)
      @sheet = sheet
      @remessa = remessa
    end

    def call
      result = ''
      header_mapping = {
        'Data da remessa' => :data_da_remessa,
        'Código MCI do Cliente no Banco' => :codigo_mci_do_cliente_no_banco,
        'Numero do processo' => :numero_do_processo,
        'Prefixo da Agência de Relacionamento' => :prefixo_da_agencia_de_relacionamento,
        'Digito verificador da agencia de relacionamento' => :digito_agencia_de_relacionamento,
        'Numero da conta do cliente' => :numero_da_conta_do_cliente,
        'Digito verificador da conta do cliente' => :digito_verificador_da_conta_do_cliente
      }

      (2..sheet.last_row).each do |row_number|
        data = SpreadsheetUtils.prepare_data(header_mapping, sheet, row_number)
        result << prepare_data(data)
      end
      result
    end

    private

    def prepare_data(data)
      '0' * 7 <<
        Date.current.strftime('%d%m%Y') <<
        'MCIF460 ' <<
        clear_string(data[:codigo_mci_do_cliente_no_banco])[0..8].rjust(9, '0') <<
        clear_string(data[:numero_do_processo])[0..4].rjust(5, '0') <<
        clear_string(@remessa)[0..4].rjust(5, '0') <<
        '04' <<
        clear_string(data[:prefixo_da_agencia_de_relacionamento])[0..3].ljust(4, '0') <<
        clear_string(data[:digito_agencia_de_relacionamento])[0.0].rjust(1, '0') <<
        clear_string(data[:numero_da_conta_do_cliente])[0..10].rjust(11, '0') <<
        clear_string(data[:digito_verificador_da_conta_do_cliente])[0..0].rjust(1, '0') <<
        '1' <<
        "#{' ' * 88}\r\n"
    end
  end
end
