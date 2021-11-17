class SpreadsheetInteractor < ApplicationInteractor
  def call
    context.txt_content = Mci460::MainService.call(context.params)
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end