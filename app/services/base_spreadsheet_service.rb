class BaseSpreadsheetService
  attr_reader :sheet

  def initialize(sheet)
    @sheet = sheet
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def clear_string(value)
    return '' unless value

    value = strip_trailing_zero(value) if value.is_a?(Numeric)
    I18n.transliterate(value.tr('/,-.:%;)(\'', '').squeeze(' ')).upcase
  end

  def extract_data(sheet, header_mapping)
    result = {}
    line   = ''
    (2..sheet.last_row).each do |row_number|
      data = SpreadsheetUtils.prepare_data(header_mapping, sheet, row_number)
      line = prepare_data(data, row_number - 1)
      raise "Quantidade de caracteres diferente de 150 #{line.size}" if line.size != 150

      result[row_number] = "#{line}\r\n"
    end
    result
  end

  def prepare_data
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  private

  def strip_trailing_zero(value)
    value.to_s.sub(/\.?0+$/, '')
  end
end
