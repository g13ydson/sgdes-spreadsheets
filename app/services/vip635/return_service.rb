module Vip635
  class ReturnService < ApplicationService
    def initialize(params)
      @file_path = params[:return_file].path
      @filename  = params[:return_file].original_filename
    end

    def call
      errors = []
      file_content = File.read(@file_path)
      file_content.gsub!(/\r\n?/, "\n")
      file_content.each_line.with_index do |line, index|
        errors << prepare_errors(line) unless index.zero?
      end
      { errors: errors, header: prepare_header(file_content), filename: @filename }
    end

    def prepare_errors(line)
      {
        sequencial: line[6..10],
        cpf: line[11..24],
        ocorrencia1: ocorrencia(line[110..112]),
        ocorrencia2: ocorrencia(line[113..115]),
        ocorrencia3: ocorrencia(line[116..118])
      }
    end

    def prepare_header(line)
      byebug
      {
        numero_remessa: line[21..25],
        sequencial_remessa: line[26..30],
        data_da_remessa: line[5..12]
      }
    end

    def ocorrencia(code)
      code.sub!(/^0+/, '')
      {
        '1' => 'TIPO PESSOA INVALIDO',
        '2' => 'TIPO CPF/CGC INVALIDO',
        '3' => 'CPF/CGC INVALIDO',
        '4' => 'DATA NASCIMENTO INVALIDA',
        '5' => 'NOME CLIENTE INVALIDO',
        '6' => 'AGÊNCIA/DV INVALIDA',
        '7' => 'EXISTEM MAIS DE 5 CLIENTES CADASTRADOS PARA O CPF INFORMADO',
        '8' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '9' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '10' => 'DADOS DIVERGENTES NA RECEITA',
        '11' => 'COD. ESTADO CIVIL INVALIDO',
        '12' => 'COD. NATUREZA OCUPAÇÃO INVALIDO',
        '13' => 'COD. OCUPAÇÃO INVALIDO',
        '14' => 'VALOR RENDIMENTO INVALIDO',
        '15' => 'DATA RENDIMENTO INVALIDA',
        '16' => 'TIPO CONTRATO TRABALHO INVALIDO',
        '17' => 'DATA INÍCIO EMPREGO INVALIDA',
        '18' => 'NÃO ATENDE A POLITICA DE CREDITO ADOTADA PELO BB',
        '19' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '20' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '21' => 'CNPJ DA UNIDADE INVALIDO',
        '22' => 'NÚMERO IDENTIFICADOR DO CENTRO DE CUSTOS INVALIDO',
        '23' => 'UNIDADE DE FATURAMENTO NÃO LOCALIZADA',
        '24' => 'NOME DO PORTADOR INVALIDO',
        '25' => 'LIMITE GERAL DO PORTADOR INVALIDO',
        '26' => 'TIPO DO CARTÃO INVALIDO',
        '27' => 'DIA DO VENCIMENTO DA FATURA INVALIDO',
        '28' => 'INDICADOR DE DÉBITO EM CONTA INVALIDO',
        '29' => 'PREFIXO/DV AGÊNCIA PARA DÉBITO INVALIDO',
        '30' => 'NÚMERO DA CONTA/DV PARA DÉBITO INVALIDO',
        '31' => 'NÚMERO DA CONTA/DV PARA DÉBITO INVALIDO OU FALTA REG TIPO 12',
        '32' => 'CÓDIGO DO ENDERECO PARA FATURA INVALIDO',
        '33' => 'INDICADOR DE ANTECIPACAO DE SAQUE INVALIDO',
        '34' => 'CÓDIGO DO TIPO DE ESTABELECIMENTO AUTORIZADO INVALIDO',
        '35' => 'LIMITE DIARIO DO PORTADOR DE CARTÃO EMPRESARIAL INVALIDO',
        '36' => 'LIMITE SEMANAL DO PORTADOR DE CARTÃO EMPRESARIAL INVALIDO',
        '37' => 'LIMITE MENSAL DO PORTADOR DE CARTÃO EMPRESARIAL INVALIDO',
        '38' => 'FALTA REG. TIPO 11 QUE IDENTIFICA O CEN DE CUSTO EMPRESARIAL',
        '39' => 'CENTRO DE CUSTOS NÃO LOCALIZADO OU ENCERRADO',
        '40' => 'NUM.DA UNID. DE FATUR. NÃO INFORMADO',
        '41' => 'CÓDIGO DO TIPO DE CARTÃO INVALIDO',
        '42' => 'DIA DO VENCIMENTO DA FATURA INVALIDO',
        '43' => 'INDICADOR DE DÉBITO EM CONTA INVALIDO',
        '44' => 'PREFIXO DA AG/DV PARA DÉBITO EM CONTA INVALIDO',
        '45' => 'CONTA CORRENTE/DV PARA DÉBITO EM CONTA INVALIDO',
        '46' => 'INDICADOR DE MALA DIRETA INVALIDO ',
        '47' => 'INDICADOR DE REMESSA DE CARTÃO PELO CORREIO INVALIDO',
        '48' => 'INDICADOR DE PROTECAO 48 HS INVALIDO',
        '49' => 'NOME DO TITULAR PARA CONSTAR NO CARTÃO INVALIDO',
        '50' => 'NOME DO ADICIONAL PARA CONSTAR NO CARTÃO INVALIDO',
        '51' => 'PROPOSTA DO TITULAR FOI REJEITADA',
        '52' => 'CLIENTE SEM SUB-LIMITE NO ANC',
        '53' => 'LIMITE DE CARTÃO DO ANC JA UTILIZADO',
        '54' => 'LIMITE DISPONIVEL ABAIXO DO MINIMO DA MODALIDADE',
        '55' => 'ADICIONAL - CPF DO TITULAR INFORMADO NÃO CONFERE',
        '56' => 'ADICIONAL - CONTA DO TITULAR ENCERRADA',
        '57' => 'ADICIONAL JA CADASTRADO',
        '58' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '59' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '60' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '61' => 'DOCUMENTACAO NÃO RECEBIDA',
        '62' => 'DOCUMENTACAO INCOMPLETA',
        '63' => 'NÃO FOI POSSIVEL CONTATAR O CLIENTE (TELEMARKETING)',
        '64' => 'DUPLICIDADE',
        '65' => 'CLIENTE FALECIDO',
        '66' => 'CLIENTE DESISTIU',
        '67' => 'FONE INEXISTENTE OU NÃO PERTENCE AO CLIENTE',
        '68' => 'NÃO INSCRITO NA INSTITUIÇÃO',
        '69' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '70' => 'CPF INVALIDO NO APLICATIVO CLIENTES.',
        '71' => 'ADICIONAL - CPF INVALIDO',
        '72' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '73' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '74' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '75' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '76' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '77' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '78' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '79' => 'RMS RECUSADA',
        '80' => 'CORRENTISTA EM PROCESSO DE NÃO CORRENTISTA',
        '81' => 'RMS RECUSADA - SEQUENCIAL RMS INVALIDO',
        '82' => 'RMS RECUSADA - COD.EMPRESA INVALIDO',
        '83' => 'RMS RECUSADA - REG/ARQ FORA DE SEQUENCIA',
        '84' => 'CLIENTE E BB GIRO AUTOMATICO CADASTRADO OU PEND. DEFERIMENT',
        '85' => 'NÃO UTILIZAR',
        '86' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '87' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '88' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '89' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '90' => 'NÃO UTILIZAR',
        '91' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '92' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '93' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '94' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '95' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '96' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '97' => 'CÓDIGO DE ERRO SEM DESCRIÇÃO - CONTATAR ANALISTA DO SISTEMA',
        '98' => 'TESTE -- TESTE CONTATAR ANALISTA DO SISTEMA',
        '99' => 'CENTRO DE CUSTOS EMPRESARIAL NÃO ENCONTRADO OU ENCERRADO',
        '100' => 'RMS RECUSADA - MATRICULA DO PORTADOR EM BRANCO',
        '101' => 'DUPLICIDADE - PORTADOR JÁ CADASTRADO',
        '102' => 'DUPLICIDADE - PORTADOR JÁ CADASTRADO',
        '105' => 'CONTA INTEGRACAO INATIVA',
        '107' => 'ALTERACAO DE LIMITE PARA CONTA ENCERRADA',
        '108' => 'LIMITE JA CADASTRADO',
        '109' => 'LIMITE DA COOPERATIVA ESGOTADO',
        '110' => 'LIMITE DA CONTA INVALIDO',
        '111' => 'INDICADOR DE ENCERRAMENTO/ BLOQUEIO INVALIDO',
        '112' => 'INDICADOR DE TITULAR DA CONTA CARTÃO INVALIDO',
        '113' => 'CÓDIGO DO CLIENTE NÃO LOCALIZADO NO MCI.',
        '114' => 'SEQUENCIAL DE TITULARIDADE INVALIDO.',
        '115' => 'CONTA CARTÃO INVALIDA',
        '116' => 'NOME DO ARQUIVO INVALIDO',
        '117' => 'CONVENIO NÃO ATIVO.',
        '118' => 'AGÊNCIA E CONTA INVALIDA',
        '119' => 'CONVENIO NÃO CADASTRADO',
        '120' => 'TIPO DO ARQUIVO NÃO ENCONTRADO',
        '121' => 'SEQUENCIAL DE REMESSA INVALIDO',
        '122' => 'SEQUENCIAL DE REMESSA NÃO ENCONTRADO',
        '123' => 'QUANTIDADE DE REGISTROS INVALIDA',
        '124' => 'QUANTIDADE DE CLIENTES INVALIDA',
        '125' => 'SEQUENCIAL DE ARQUIVO FORA DE ORDEM',
        '126' => 'QUANTIDADE DE REGISTROS SUPERIOR A 2',
        '127' => 'CONTA INTEGRACAO NÃO CADASTRADA',
        '128' => 'CONTA INTEGRAÇÃO INVALIDA',
        '129' => 'PERMISSÃO INCONSISTENTE COM A UNIDADE DE FATURAMENTO',
        '130' => 'CONTROLE DE RAMO DE ATIVIDADE NÃO PERMITIDO PARA O PORTADOR',
        '131' => 'VALOR MÁXIMO POR TRANSAÇÃO MAIOR QUE O LIMITE DO PORTADOR',
        '132' => 'VALOR MÁXIMO INTERNET/EXTERIOR MAIOR QUE VL MÁXIMO TRANSAÇÃO',
        '133' => 'VALOR MÁXIMO TRANSAÇÃO MAIOR QUE O DO NIVEL SUPERIOR.',
        '134' => 'FALTA DADOS PERTINENTE A PERMISSOES DE USO/CONTROLE DE GASTO',
        '135' => 'MODALIDADE INVALIDA',
        '136' => 'CLIENTE NÃO CADASTRADO NA BASE DO EMPRESARIAL.',
        '137' => 'NOVO LIMITE MAIOR QUE O DO CENTRO DE CUSTO',
        '138' => 'LIMITE MÁXIMO MAIOR QUE LIMITEDA EMPRESA',
        '139' => 'LIMITE MÁXIMO MAIOR QUE LIMITEDO PORTADOR',
        '140' => 'LIMITE INFORMADO MAIOR QUE O DA UNIDADE DE FATURAMENTO',
        '141' => 'DATA INVALIDA',
        '142' => 'SUBMODALIDADE INVALIDA',
        '143' => 'NÚMERO CARTÃO OU DADOS DA CONTA CARTÃO INVALIDOS',
        '144' => 'VALOR NÃO NUMERICO NOS LIMITESMÁXIMO DO PORTADOR',
        '145' => 'LIMITE MÁXIMO/TRANSAÇÃO MENOR QUE LIM.MAX/TRANS INRT/EXTR',
        '146' => 'NÃO ENCONTROU REGISTRO VISION PARA ALTERACAO',
        '147' => 'LIMITE MENSAL, SEMANAL, DIARIOMAIOR QUE NOVO LIMITE',
        '148' => 'LIMITE SEMANAL MAIOR QUE LIMITE MENSAL',
        '149' => 'LIMITE DIARIO MAIOR QUE LIMITESEMANAL',
        '150' => 'INDICADOR DE ADICIONAL E REDUCAO INVALIDO',
        '151' => 'INDICADOR DE PERMISSÃO PARA UTILIZACAO NO EXTERIOR INVALIDO',
        '152' => 'INDICADOR DE PERMISSÃO PARA COMPRA PARCELADA INVALIDO',
        '153' => 'INDICADOR DE PERMISSÃO PARA COMPRA NA INTERNET INVALIDO',
        '154' => 'INDICADOR DE PERMISSÃO PARA SAQUE INVALIDO',
        '155' => 'LIMITE INFORMADO PARA TIPO DE ESTABELECIMENTO INVALIDO',
        '156' => 'INDICADOR DE PERMISSÃO INFORMADO DIFERE DA UNID. FATURAMENTO',
        '157' => 'VALOR MÁXIMO MAIOR QUE O NOVO LIMITE',
        '158' => 'VALOR DO LIMITE CONCEDIDO MENOR QUE R$ 200,00',
        '159' => 'CLIENTE COM SITUACAO/INCONSISTENCIA RESTRITIVA - RNA',
        '160' => 'CLIENTE COM TIPO DE CADASTRO INCOMPATIVEL - RNA',
        '161' => 'CLIENTE C/ SITUAC/INCONS. RESTRITIVA E CADASTRO INCOMPATIVEL',
        '162' => 'CLIENTE REJEITADO - PMA NÃO INFORMADA',
        '163' => 'REMESSA RECUSADA - CONVENIO INVALIDO',
        '164' => 'CLIENTE REJEITADO - MDLD INVALIDA/NÃO INFORMADA',
        '165' => 'DUPLICIDADE - TIP. ESTABELECIMENTO JA CASDASTRADO',
        '166' => 'AG/CT-COOPERADO NÃO LOCALIZADA',
        '167' => 'CPF COM CADASTRO DUPLICADO NO BB - CONTATE AGÊNCIA',
        '168' => 'CNPJ COM CADASTRO DUPLICADO NO BB - CONTATE AGÊNCIA',
        '169' => 'CELULAR - DDD INVALIDO',
        '170' => 'CELULAR - NÚMERO INVALIDO',
        '171' => 'CELULAR - OPERADORA INVALIDA',
        '172' => 'CELULAR - ERRO NO CADASTRAMENTO',
        '173' => 'TIPO DE CADASTRO DA SENHA INVALIDO',
        '174' => 'MODALIDADE/SUB-MDLD NÃO PERMITE ENVIO DE SENHA VIA SMS',
        '200' => 'ANC SEM LIMITE ESTABELECIDO',
        '222' => 'REJEITADO - CLIENTE FALECIDO',
        '223' => 'REJEITADO - NINGUEM ATENDE (APOS 6 DIAS DE TENTATIVA)',
        '224' => 'REJEITADO - NÚMERO ERRADO/INEXISTENTE',
        '225' => 'CLIENTE DESCONHECIDO P/ INTERLOCUTOR (QUANDO NÚMERO CONFERE)',
        '226' => 'REJEITADO - CLIENTE COM LIMITE FORA DA FAIXA DE ABORDAGEM',
        '250' => 'REJEITADO - SEM LIMITE DE CREDITO - ANC',
        '268' => 'SMILES PERMITIDO SOMENTE APOS EMISSAO DO CARTÃO DO TITULAR',
        '320' => 'CLIENTE SEM CONTROLE DE GASTOS',
        '328' => 'ERRO NO CADASTRAMENTO ENDERECO NO MCI',
        '329' => 'PORTADOR NÃO LOCALIZADO OU ENCERRADO',
        '330' => 'LIMITE CENTRO DE CUSTO MAIOR QUE O MÁXIMO DA MODALIDADE',
        '331' => 'MODALIDADE NÃO ADMITIDA PARA CLIENTE CORRENTISTA',
        '332' => 'MODALIDADE NÃO ADMITIDA PARA CLIENTE NÃO CORRENTISTA',
        '333' => 'ERRO NA ALTERACAO DO LIMITE DO PORTADOR',
        '334' => 'TITULO RAZAO DA CONTA CORRENTE NÃO PERMITE CARTÃO',
        '335' => 'PESSOA POLITICAMENTE EXPOSTA NÃO AUTORIZADA PARA REL NEGOCIO',
        '336' => 'PESSOA POLITICAMENTE EXPOSTA SEM AUTORIZADA PARA REL NEGOCIO',
        '338' => 'BCP - CAPACIDADE CIVIL INVALIDA',
        '339' => 'CÓDIGO DO CONVENIO / TIPO DE PLASTICO NÃO CADASTRADO',
        '401' => 'ERRO NA INCLUSAO DO PORTADOR',
        '402' => 'ERRO NA INCLUSAO DA CONTA CARTÃO',
        '454' => 'BLOQUEIO DE CONTA CARTÃO COOPERATIVO REJEITADO',
        '455' => 'DESBLOQUEIO DE CONTA CARTÃO COOPERATIVO REJEITADO',
        '456' => 'ENCERRAMENTO DE CONTA CARTÃO COOPERATIVA REJEITADO',
        '457' => 'LOGRADOURO DO ENDERECO RESIDENCIAL INVALIDO',
        '458' => 'BAIRRO DO ENDERECO RESIDENCIAL INVALIDO',
        '459' => 'LOGRADOURO DO ENDERECO COMERCIAL INVALIDO',
        '460' => 'BAIRRO DO ENDERECO COMERCIAL INVALIDO',
        '461' => 'NOME DO PORTADOR INFORMADO PARA O CARTÃO INVALIDO',
        '462' => 'ERRO NO CADASTRAMENTO DO ENDERECO DO PORTADOR',
        '463' => 'ENDERECO DO CENTRO DE CUSTO ESTA INCONSISTENTE',
        '464' => 'QUANTIDADE DE ADICIONAL EXCEDIDO PARA O MCI',
        '953' => 'VIPPC189-ERRO INESPERADO NO SISTEMA, FAVOR TENTAR NOVAMENTE'
      }[code]
    end
  end
end
