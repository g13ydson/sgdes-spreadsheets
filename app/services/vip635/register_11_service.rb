module Vip635
  class Register11Service < BaseSpreadsheetService
    def call
      extract_data(sheet)
    end

    private

    def prepare_data(data, row_number)
      row_number[0..4].to_s.rjust(5, '0') <<
        '11' <<
        data[:cnpj_do_centro_de_custo][0..13].rjust(14, '0') <<
        '000000010' << # Centro de custo
        '000000000' << # Unidade de faturamento
        data[:nome_personalizado_do_portador_para_o_cartao][0..18].ljust(19, ' ') <<
        data[:limite_do_portador][0..8].rjust(9, '0') <<
        data[:codigo_do_endereco_para_envio_do_extrato_cartao][0..0].rjust(1, '0') <<
        data[:codigo_do_endereco_para_envio_do_demonstrativo][0..0].rjust(1, '0') <<
        data[:permissao_para_usar_no_exterior][0..0].rjust(1, '0') <<
        data[:permissao_para_compra_parcelada][0..0].rjust(1, '0') <<
        data[:permissao_para_compras_pela_internet_ou_telefone][0..0].rjust(1, '0') <<
        data[:permissao_para_saques_na_conta_cartao][0..0].rjust(1, '0') <<
        data[:valor_maximo_por_transacao][0..8].rjust(9, '0') <<
        data[:valor_maximo_para_transacao_na_internet_ou_telefone][0..8].rjust(9, '0') <<
        data[:valor_maximo_para_transacao_no_exterior][0..8].rjust(9, '0') <<
        data[:codigo_da_operadora][0..4].rjust(5, '0') <<
        data[:numero_ddd_do_celular][0..2].rjust(3, '0') <<
        data[:numero_do_celular][0..8].rjust(9, '0') <<
        '00' <<
        ' ' * 31
    end
  end
end
