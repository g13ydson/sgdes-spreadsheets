module Mci460
  class Register01Service < BaseSpreadsheetService
    def call
      header_mapping = {
        'Número do CPF/CNPJ' => :numero_do_cpf,
        'Data de Nascimento' => :data_de_nascimento,
        'Nome do Cliente' => :nome_cliente,
        'Nome Personalizado Cliente' => :nome_personalizado_cliente,
        'Número do Programa do Gestão Ágil' => :numero_programa_agil,
        'Prefixo da Agência onde a Conta está sendo Aberta' => :prefixo_da_agencia_onde_a_conta_esta_sendo_aberta,
        'Digito verificador do Prefixo da Agência onde a Conta está sendo Aberta' => :digito_verificador_do_prefixo_da_agencia_onde_a_conta_esta_sendo_aberta
      }

      extract_data(sheet, header_mapping)
    end

    private

    def prepare_data(data, row_number)
      row_number.to_s[0..4].rjust(5, '0') <<
        '01'  <<
        '2'   <<
        '3'   <<
        clear_string(data[:numero_do_cpf]).to_s[0..13].ljust(14, '0') <<
        clear_string(data[:data_de_nascimento].to_s)[0..7].rjust(8, '0') <<
        clear_string(data[:nome_cliente].to_s)[0..59].ljust(60, ' ') <<
        clear_string(data[:nome_personalizado_cliente].to_s)[0..24].rjust(25, ' ') <<
        ' ' <<
        '0' * 8 <<
        data[:numero_programa_agil].to_s[0..8].ljust(9, ' ') <<
        data[:prefixo_da_agencia_onde_a_conta_esta_sendo_aberta].to_s[0..3].ljust(4, ' ') <<
        data[:digito_verificador_do_prefixo_da_agencia_onde_a_conta_esta_sendo_aberta].to_s[0..0].rjust(1, ' ') <<
        '01'  <<
        '9'   <<
        '000' <<
        '01'  <<
        '000'
    end
  end
end
