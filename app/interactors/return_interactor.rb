class ReturnInteractor < ApplicationInteractor
  def call
    context.error_msgs = case context.params[:layout]
                         when 'vip635'
                           Vip635::ReturnService.call(context.params)
                         when 'mci460'
                           Mci460::ReturnService.call(context.params)
                         else
                           context.fail!(message: 'Layout não encontrado')
                         end
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end
