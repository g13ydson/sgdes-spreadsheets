module Mci460
  class ReturnService < ApplicationService
    def initialize(params)
      @file_path = params[:return_file].path
    end

    def call
      error_msgs = []
      file_content = File.read(@file_path)
      file_content.gsub!(/\r\n?/, "\n")
      file_content.each_line.with_index do |line, index|
        error_msgs << prepare_msg(line) unless index.zero?
      end
      error_msgs
    end

    def prepare_msg(line)
      error_msg = "SEQUENCIAL: #{line[0..4]} - CPF: #{line[5..18]}"
      error_msg << " - Ocorrência Cliente: #{ocorrencia_cliente(line[124..126])}" if line[124..126] != '000'
      error_msg << " - Ocorrência conta: #{ocorrencia_conta(line[127..129])}" if  line[127..129] != '000'
      if line[130..132] != '000'
        error_msg << " - Ocorrência limite de crédito: #{ocorrencia_limite_credito(line[130..132])}"
      end
      error_msg
    end

    def ocorrencia_cliente(code)
      {
        '001' => 'tipo pessoa inválido',
        '002' => 'tipo CPF/CNPJ inválido',
        '003' => 'CPF/CNPJ inválido',
        '004' => 'data nascimento invalida,',
        '005' => 'nome cliente inválido',
        '006' => 'agência/dv inválido',
        '007' => 'mais de 5 clientes cadastrados para CPF informado',
        '008' => 'cliente BB-Campus fora da faixa etária (16 a 28 anos)',
        '009' => 'cliente BBCampus não é pessoa física',
        '010' => 'dados pessoa física divergentes',
        '011' => 'dados pessoa jurídica divergentes',
        '013' => 'cliente BBCampus não titular CPF',
        '014' => 'perfil agência incompatível com tipo pessoa',
        '015' => 'tipo de pessoa incompátivel com natureza jurídica',
        '016' => 'tipo de repasse inválido',
        '017' => 'tipo de pessoa não permitido para esse processo/tipo de repasse'
      }[code]
    end

    def ocorrencia_conta(code)
      {
        '001' => 'ind cheque especial inválido',
        '002' => 'setex/dv inválido',
        '003' => 'não atende ao credit scoring',
        '004' => 'dados pessoa física divergente'
      }[code]
    end

    def ocorrencia_limite_credito(code)
      {
        '001' => 'cod estado civil inválido',
        '002' => 'cod natureza ocupação inválido',
        '003' => 'cod ocupação inválido',
        '004' => 'valor rendimento inválido',
        '005' => 'data rendimento invalida',
        '006' => 'tipo contrato trabalho inválido',
        '007' => 'data início emprego inválida',
        '008' => 'nao atende ao credit scoring'
      }[code]
    end
  end
end
