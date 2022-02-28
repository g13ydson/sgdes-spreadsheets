class SpreadsheetInteractor < ApplicationInteractor
  def call
    context.txt_content = case context.params[:layout]
                          when "vip635"
                            Vip635::MainService.call(context.params)
                          when "mci460"
                            Mci460::MainService.call(context.params)
                          when "vip634"
                            Vip634::MainService.call(context.params)
                          else
                            context.fail!(message: "Layout não encontrado")
    end
  rescue => e
    context.fail!(message: e.message)
  end
end
