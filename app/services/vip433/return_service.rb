module Vip433
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
        if line[0] == "4"
          errors << prepare_errors(line) unless index.zero?
        end
      end
      {errors: errors, header: prepare_header(file_content), filename: @filename}
    end

    def prepare_errors(line)
      {
        numero_do_cartao: line[1..19],
        cpf_portador_cartao: line[470..480],
        nome_portador_cartao: line[450..469],
        codigo_inep: codigo_inep(line[450..469]),
        localizacao_portador_cartao: line[243..251],
        nome_centro_custo: line[410..429],
        nome_unidade_faturamento: line[430..449],
        data_confirmacao_transacao: Date.strptime(line[20..27], "%d%m%Y").strftime("%d/%m/%Y"),
        razao_social: line[99..124],
        nome_estabelecimento: line[99..124],
        cidade: line[125..138],
        uf: line[139..142],
        valor_transacao_original: to_reais(line[158..173]),
        valor_transacao_nacional: to_reais(line[174..189]),
        data_transacao: Date.strptime(line[202..209], "%d%m%Y").strftime("%d/%m/%Y"),
        horario: line[534..541],
        codigo_atividade: line[195..199],
        debito_credito: line[338..339],
        descricao: line[340..389],
        nome_atividade_fornecedor: line[491..519],
        cpf_cnpj: format_cpf_cnpj(line[520..533])
      }
    end

    def prepare_header(line)
      {
        numero_remessa: line[11..15],
        quantidade_registros: line[26..35],
        data_da_remessa: line[16..23],
        somatorio: line[36..51]
      }
    end

    private

    def format_cpf_cnpj(number)
      return CNPJ.new(number).formatted if CNPJ.valid?(number)
      cpf_number = number[-11..14]
      return CPF.new(cpf_number).formatted if CPF.valid?(cpf_number)
      number
    end

    def to_reais(number)
      Money.from_cents(number, "BRL").format
    end

    def codigo_inep(value)
      value.scan(/\d+/).first
    end
  end
end
