class SpreadsheetsController < ApplicationController
  def create
    result = SpreadsheetInteractor.call(params: spreadsheet_params)

    if result.success?
      send_data(result.txt_content.encode("cp1252"), type: "text/plain", disposition: "attachment",
                                    filename: "#{spreadsheet_params[:file_name]}.txt")
    else
      redirect_to root_path, alert: result.message
    end
  end

  def return
    result = ReturnInteractor.call(params: spreadsheet_return_params)
    @return_result = result.error_msgs

    if result.success? && @return_result[:errors].any?
      if params[:layout] == "mci460"
        render "spreadsheets/mci460/return_result.xlsx.axlsx"
      elsif params[:layout] == "vip635"
        render "spreadsheets/vip635/return_result.xlsx.axlsx"
      end
    else
      redirect_to root_path, alert: result.message
    end
  end

  def return_result
  end

  private

  def spreadsheet_params
    params.permit(:layout, :sequencial, :spreadsheet_id, :file_name)
  end

  def spreadsheet_return_params
    params.permit(:layout, :return_file)
  end
end
