module PryParsecom
  class Table
    attr_accessor :indent

    def initialize heads, indent='  ', rows=[]
      @heads = heads
      @indent = indent
      @col_widths = Hash.new 0
      @heads.each do |head|
        @col_widths[head] = head.size
      end
      self.rows = rows
    end

    def rows= rows
      @rows = []
      rows.each do |row|
        add_row row
      end
    end

    def add_row row
      cols = []
      case row
      when Hash
        @heads.each do |head|
          cols << row[head]
        end
      when Array
        cols = row
      else
        cols = [row]
      end

      cols.each.with_index do |col, i|
        if @col_widths[i] < col.size
          @col_widths[i] = col.size
        end
      end
      @rows << cols
    end

    def to_s
      heads = @heads.map.with_index do |head, i|
        head.center @col_widths[i]
      end.join " | "
      ret = heads
      ret += "\n"
      ret += '=' * heads.size
      ret += "\n"
      @rows.each do |row|
        ret += row.map.with_index { |col, i|
          col.ljust @col_widths[i]
        }.join " | "
        ret += "\n"
      end
      ret.gsub /^/, @indent
    end
  end
end
