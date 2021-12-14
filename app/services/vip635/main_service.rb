module Vip635
  class MainService < ApplicationService
    def initialize(params)
      @spreadsheet_id = params[:spreadsheet_id]
      @sequencial     = params[:sequencial]
    end

    def call
      registers = {}
      spreadsheet = Roo::Spreadsheet.open(
        "https://docs.google.com/spreadsheets/d/#{@spreadsheet_id}/export\?format\=xlsx", extension: :xlsx
      )

      registers[:header]      = Vip635::HeaderService.call(spreadsheet.sheet('Header'), @sequencial)
      registers[:register01]  = Vip635::Register01Service.call(spreadsheet.sheet('Registro detalhe 01'))
      registers[:register06]  = Vip635::Register06Service.call(spreadsheet.sheet('Registro detalhe 06'))
      registers[:register07]  = Vip635::Register07Service.call(spreadsheet.sheet('Registro detalhe 07'))
      registers[:register11]  = Vip635::Register11Service.call(spreadsheet.sheet('Registro detalhe 11'))
      registers[:register12]  = Vip635::Register12Service.call(spreadsheet.sheet('Registro detalhe 12'))
      registers[:trailer]     = RegisterTrailerService.call(registers)
      Vip635::FileService.call(registers)
    end
  end
end
