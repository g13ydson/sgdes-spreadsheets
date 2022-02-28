module Vip634
  class MainService < ApplicationService
    def initialize(params)
      @spreadsheet_id = params[:spreadsheet_id]
      @sequencial = params[:sequencial]
    end

    def call
      registers = {}
      spreadsheet = Roo::Spreadsheet.open(
        "https://docs.google.com/spreadsheets/d/#{@spreadsheet_id}/export\?format\=xlsx", extension: :xlsx
      )

      registers[:header] = Vip634::HeaderService.call(spreadsheet.sheet("HEADER"), @sequencial)
      registers[:register01] = Vip634::Register01Service.call(spreadsheet.sheet("DETALHE"))
      registers[:trailer] = Vip634::RegisterTrailerService.call(registers)
      Vip634::FileService.call(registers)
    end
  end
end
