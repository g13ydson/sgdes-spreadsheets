class SpreadsheetUtils
  def self.prepare_data(header_mapping, sheet, row_number)
    data = [sheet.row(1), sheet.row(row_number)].transpose.to_h
    header_mapping.values.zip(data.values_at(*header_mapping.keys)).to_h
  end
end
