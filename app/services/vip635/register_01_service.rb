module Vip635
  class Register01Service < BaseSpreadsheetService
    def prepare_data(data, row_number)
      row_number[0..4].to_s.rjust(5, '0') <<
        '01'  <<
        '0'   <<
        '1'   <<
        data[:numero_do_cpf][0..13].rjust(14, '0') <<
        data[:data_de_nascimento][0..7].rjust(8, '0') <<
        data[:nome_completo][0..59].ljust(60, ' ') <<
        data[:matricula][0..7].ljust(8, ' ') <<
        data[:localizacao][0..8].ljust(9, ' ') <<
        ' ' * 9 <<
        data[:uso_da_empresa][0..16].rjust(17, '0') <<
        '1618' << # Número do prefixo da agência do cliente governo
        '7' << # Digito verificador do prefixo da agência do cliente governo
        '411916051' << # CÓDIGO FIXO MCI
        '  '
    end
  end
end
