module Vip635
  class Register06Service < BaseSpreadsheetService
    def prepare_data(data, row_number)
      row_number[0..4].rjust(5, "0") <<
        "06" <<
        data[:endereco_do_portador][0..59].ljust(60, " ") <<
        data[:bairro_do_portador][0..20].ljust(30, " ") <<
        data[:cep_do_portador][0..7].rjust(8, "0") <<
        data[:ddd_do_telefone_do_portador][0..3].rjust(4, "0") <<
        data[:numero_do_telefone_do_portador][0..8].rjust(9, "0") <<
        " " * 9 <<
        data[:situacao_do_imovel_do_portador][0..1].ljust(2, " ") <<
        data[:data_que_o_portador_comecou_a_residir_no_imovel][0..5].rjust(6, "0") <<
        " " * 15
    end
  end
end
