class BaseSpreadsheetService < ApplicationService
  attr_reader :sheet

  def initialize(sheet)
    @sheet = sheet
  end

  def call
    extract_data
  end

  def extract_data
    result = {}
    line = ""
    header_mapping = sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }.to_h

    (2..sheet.last_row).each do |row_number|
      data = row_data(header_mapping, sheet, row_number)
      data = normalize_values(data)
      line = prepare_data(data, (row_number - 1).to_s)

      raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

      result[row_number] = "#{line}\n"
    end
    result
  end

  def prepare_data
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def row_data(header_mapping, sheet, row_number)
    data = [sheet.row(1), sheet.row(row_number)].transpose.to_h
    header_mapping.values.zip(data.values_at(*header_mapping.keys)).to_h
  end

  private

  def normalize_values(data)
    data.deep_transform_values { |value| clear_string(format_date(value)) }
  end

  def clear_string(value)
    return "" unless value

    value = value.to_s if value.is_a?(Numeric)
    I18n.transliterate(value.tr("/,-.:%;)('", "").squeeze(" ")).upcase
  end

  def format_date(value)
    return "" unless value

    return value.strftime("%d%m%Y") if value.is_a?(Date)

    value
  end

  def strip_trailing_zero(value)
    value.to_s.sub(/\.?0+$/, "")
  end
end
