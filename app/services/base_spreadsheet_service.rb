class BaseSpreadsheetService
  attr_reader :sheet

  def initialize(sheet)
    @sheet = sheet
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def extract_data(sheet)
    result          = {}
    line            = ''
    header_mapping  = Hash[sheet.first.map { |v| [v, v.parameterize.underscore.to_sym] }]

    (2..sheet.last_row).each do |row_number|
      data = row_data(header_mapping, sheet, row_number)
      data = normalize_values(data)
      line = prepare_data(data, row_number - 1)
      raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

      result[row_number] = "#{line}\r\n"
    end
    result
  end

  def prepare_data
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def row_data(header_mapping, sheet, row_number)
    data = Hash[[sheet.row(1), sheet.row(row_number)].transpose]
    header_mapping.values.zip(data.values_at(*header_mapping.keys)).to_h
  end

  private

  def normalize_values(data)
    data.deep_transform_values { |value| format_date(clear_string(value)) }
  end

  def clear_string(value)
    return '' unless value

    value = strip_trailing_zero(value) if value.is_a?(Numeric)
    I18n.transliterate(value.tr('/,-.:%;)(\'', '').squeeze(' ')).upcase
  end

  def format_date(value)
    return '' unless value

    return value.strftime('%m%d%Y') if value.is_a?(Date)

    value
  end

  def strip_trailing_zero(value)
    value.to_s.sub(/\.?0+$/, '')
  end
end
