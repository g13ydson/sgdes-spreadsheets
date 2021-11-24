class ReturnInteractor < ApplicationInteractor
  def call
    context.error_msgs = Mci460::ReturnService.call(context.params)
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end