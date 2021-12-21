module Mci460
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

      registers[:header]      = Mci460::HeaderService.call(spreadsheet.sheet('HEADER'), @sequencial)
      registers[:register01]  = Mci460::Register01Service.call(spreadsheet.sheet('DETALHE'))
      registers[:trailer]     = Mci460::RegisterTrailerService.call(registers)
      Mci460::FileService.call(registers)
    end
  end
end
