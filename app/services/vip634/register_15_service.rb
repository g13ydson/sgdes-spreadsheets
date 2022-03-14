module Vip634
  class Register15Service < BaseSpreadsheetService
    def prepare_data(data, row_number)
      row_number[0..4].rjust(5, "0") <<
        "15" <<
        " " * 19 <<
        data[:numero_do_cartao_do_portador][0..18].ljust(19, "0") <<
        data[:data_de_validade_do_limite][0..7].ljust(8, "0") <<
        data[:valor_referente_ao_novo_limite_do_portador][0..10].ljust(11, "0") <<
        data[:valor_maximo_por_transacao_sem_centados][0..10].ljust(11, "0") <<
        data[:valor_maximo_por_transacao_na_internet_ou_telefone_sem_centados][0..10].ljust(11, "0") <<
        data[:valor_maximo_de_transacao_no_exterior_sem_centavos][0..10].ljust(11, "0") <<
        data[:permissao_para_utilizacao_no_exterior][0..0].rjust(1, " ") <<
        data[:permissao_para_compra_parcelada][0..0].rjust(1, " ") <<
        data[:permissao_para_compras_pela_internet_ou_telefone][0..0].rjust(1, " ") <<
        data[:permissao_para_saques_na_conta_cartao][0..0].rjust(1, " ") <<
        " " * 49
    end
  end
end
