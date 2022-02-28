module Vip634
  class ReturnService < ApplicationService
    def initialize(params)
      @file_path = params[:return_file].path
      @filename = params[:return_file].original_filename
    end

    def call
      errors = []
      file_content = File.read(@file_path)
      file_content.gsub!(/\r\n?/, "\n")
      file_content.each_line.with_index do |line, index|
        errors << prepare_errors(line) unless index.zero?
      end
      {errors: errors, header: prepare_header(file_content), filename: @filename}
    end

    def prepare_errors(line)
      {
        sequencial: line[0..4],
        cpf: line[5..18],
        numero_conta: line[112..122],
        digito_conta: line[123..123],
        ocorrencia_cliente: ocorrencia_cliente(line[124..126]),
        ocorrencia_conta: ocorrencia_conta(line[127..129]),
        ocorrencia_limite_credito: ocorrencia_limite_credito(line[130..132])
      }
    end

    def prepare_header(line)
      {
        sequencial_remessa: line[26..30],
        data_da_remessa: line[5..12]
      }
    end

    def ocorrencia_cliente(code)
      {
        "000" => "",
        "001" => "tipo pessoa inválido",
        "002" => "tipo CPF/CNPJ inválido",
        "003" => "CPF/CNPJ inválido",
        "004" => "data nascimento invalida,",
        "005" => "nome cliente inválido",
        "006" => "agência/dv inválido",
        "007" => "mais de 5 clientes cadastrados para CPF informado",
        "008" => "cliente BB-Campus fora da faixa etária (16 a 28 anos)",
        "009" => "cliente BBCampus não é pessoa física",
        "010" => "dados pessoa física divergentes",
        "011" => "dados pessoa jurídica divergentes",
        "013" => "cliente BBCampus não titular CPF",
        "014" => "perfil agência incompatível com tipo pessoa",
        "015" => "tipo de pessoa incompátivel com natureza jurídica",
        "016" => "tipo de repasse inválido",
        "017" => "tipo de pessoa não permitido para esse processo/tipo de repasse"
      }[code]
    end

    def ocorrencia_conta(code)
      {
        "000" => "",
        "001" => "ind cheque especial inválido",
        "002" => "setex/dv inválido",
        "003" => "não atende ao credit scoring",
        "004" => "dados pessoa física divergente"
      }[code]
    end

    def ocorrencia_limite_credito(code)
      {
        "000" => "",
        "001" => "cod estado civil inválido",
        "002" => "cod natureza ocupação inválido",
        "003" => "cod ocupação inválido",
        "004" => "valor rendimento inválido",
        "005" => "data rendimento invalida",
        "006" => "tipo contrato trabalho inválido",
        "007" => "data início emprego inválida",
        "008" => "nao atende ao credit scoring"
      }[code]
    end
  end
end
