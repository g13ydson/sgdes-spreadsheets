module Vip634
  class Register15Service < BaseSpreadsheetService
    def extract_data
      result = {}
      line = ""
      header_mapping = sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }.to_h

      (2..sheet.last_row).each do |row_number|
        data = row_data(header_mapping, sheet, row_number)
        data = normalize_values(data)
        line = prepare_data(data, (row_number - 1).to_s)

        raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

        result[row_number] = "#{line}\r\n"
      end
      result
    end

    def prepare_data(data, row_number)
      row_number[0..4].rjust(5, "0") <<
        "15" <<
        " " * 19 <<
        data[:numero_do_cartao_do_portador][0..18].ljust(19, "0") <<
        data[:data_de_validade_do_limite][0..7].ljust(8, "0") <<
        "S" <<
        data[:valor_referente_ao_novo_limite_do_portador][0..10].rjust(11, "0") <<
        data[:valor_maximo_por_transacao_sem_centados][0..10].rjust(11, "0") <<
        data[:valor_maximo_por_transacao_na_internet_ou_telefone_sem_centados][0..10].rjust(11, "0") <<
        data[:valor_maximo_de_transacao_no_exterior_sem_centavos][0..10].rjust(11, "0") <<
        data[:permissao_para_utilizacao_no_exterior][0..0].rjust(1, " ") <<
        data[:permissao_para_compra_parcelada][0..0].rjust(1, " ") <<
        data[:permissao_para_compras_pela_internet_ou_telefone][0..0].rjust(1, " ") <<
        data[:permissao_para_saques_na_conta_cartao][0..0].rjust(1, " ") <<
        " " * 48
    end
  end
end
