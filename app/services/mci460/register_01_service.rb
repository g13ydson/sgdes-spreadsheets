module Mci460
  class Register01Service < BaseSpreadsheetService
    def prepare_data(data, row_number)
      row_number.to_s[0..4].rjust(5, '0') <<
        '01' <<
        data[:tipo_de_pessoa][0..0].ljust(1, '0') <<
        '3' <<
        data[:numero_do_cpf_cnpj][0..13].rjust(14, '0') <<
        data[:data_de_nascimento][0..7].rjust(8, '0') <<
        data[:nome_do_cliente][0..59].ljust(60, ' ') <<
        data[:nome_personalizado_cliente][0..24].ljust(25, ' ') <<
        ' ' <<
        ' ' * 17 << # uso empresa
        data[:prefixo_da_agencia_onde_a_conta_esta_sendo_aberta][0..3].rjust(4, '0') << # agencia
        data[:digito_verificador_do_prefixo_da_agencia_onde_a_conta_esta_sendo_aberta][0..0].rjust(1, ' ') << # digito agencia
        '01'  << # grupo setex
        '9'   << # dv grupo setex
        ' ' * 8
    end
  end
end
