# A stub for apps' entry point class
class Return
  attr_accessor :args

  def initialize(args)
    self.args = args
  end

  def run
    text = File.open('VIP6361714102021223608.ret').read
    text.gsub!(/\r\n?/, "\n")
    text.each_line.with_index do |line, index|
      unless index.zero?
        ap "CPF: #{line[11..24]} - COD1: #{line[110..112]} - COD2: #{line[113..115]} - COD3: #{line[116..118]}"
      end
    end
    ap "Total: #{text.lines.count}"
  end
end
