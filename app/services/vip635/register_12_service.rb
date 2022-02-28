module Vip635
  class Register12Service < BaseSpreadsheetService
    attr_reader :sheet, :count

    def initialize(sheet, count)
      @sheet = sheet
      @count = count
    end

    def call
      extract_data
    end

    def extract_data
      result = {}
      line = ""
      header_mapping = sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }.to_h

      (2..count + 1).each do |row_number|
        data = row_data(header_mapping, sheet, 2)
        data = normalize_values(data)
        line = prepare_data(data, row_number - 1)
        raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

        result[row_number] = "#{line}\n"
      end
      result
    end

    private

    def prepare_data(data, row_number)
      row_number[0..4].to_s.rjust(5, "0") <<
        "12" << # TIPO DE DETALHE. CONSTANTE E IGUAL A 12 (DOZE)
        data[:codigo_do_tipo_do_cartao][0..1].rjust(2, "0") <<
        data[:dia_de_vencimento_da_fatura][0..1].rjust(2, "0") <<
        data[:codigo_identificador_de_debito_em_conta][0..0].ljust(1, " ") <<
        data[:prefixo_da_agencia_para_debito][0..3].rjust(4, "0") <<
        data[:digito_verificador_da_agencia_de_debito][0..0].rjust(1, "0") <<
        data[:numero_da_conta_corrente_para_debito][0..10].rjust(11, "0") <<
        data[:digito_verificador_da_conta_corrente_de_debito][0..0].rjust(1, "0") <<
        data[:codigo_do_endereco_para_envio_da_fatura_extrato_cartao][0..0].rjust(1, "0") <<
        "S" << # LIQUIDACAO ANTECIPADA DE SAQUE. OBRIGATORIO INFORMAR: S - SIM;
        " " * 119 # ESPACOS EM BRANCO
    end
  end
end
