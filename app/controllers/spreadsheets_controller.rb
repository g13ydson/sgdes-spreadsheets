class SpreadsheetsController < ApplicationController
  def create
    result = SpreadsheetInteractor.call(params: spreadsheet_params)

    if result.success?
      send_data(result.txt_content, type: 'text/plain', disposition: 'attachment',
                                    filename: "#{spreadsheet_params[:file_name]}.txt")
    else
      redirect_to root_path, alert: result.message
    end
  end

  def return
    result = ReturnInteractor.call(params: spreadsheet_return_params)
    @error_msgs = result.error_msgs
    if result.success? && @error_msgs.any?
      render :return_result
    else
      redirect_to root_path, alert: result.message
    end
  end

  def return_result; end

  private

  def spreadsheet_params
    params.permit(:layout, :sequencial, :spreadsheet_id, :file_name)
  end

  def spreadsheet_return_params
    params.permit(:return_file)
  end
end
