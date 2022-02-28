module Vip635
  class Register07Service < BaseSpreadsheetService
    def prepare_data(data, row_number)
      row_number[0..4].to_s.rjust(5, "0") <<
        "07" <<
        data[:endereco_do_trabalho][0..59].ljust(60, " ") <<
        data[:bairro_do_trabalho][0..29].ljust(30, " ") <<
        data[:numero_do_cep_do_trabalho][0..7].rjust(8, "0") <<
        data[:numero_do_ddd_do_telefone_de_trabalho][0..3].rjust(4, "0") <<
        data[:numero_do_telefone_do_trabalho][0..8].rjust(9, "0") <<
        data[:numero_do_ramal_do_telefone][0..19].rjust(20, "0") <<
        " " * 9 <<
        " " * 3
    end
  end
end
