class ReplaceStringJoinOnRangesAST
    
  def map(ast)
    return ast unless ast.is_a?(Array)
    ast.each do |a| 
      next unless a.is_a?(Array)
      case ast.first
      when :error, :null, :space, :prefeix, :boolean_true, :boolean_false, :number, :string
        next
      when :sheet_reference, :table_reference, :local_table_reference
        next
      else
        map(a)
      end
    string_join(ast) if ast[0] == :string_join
    end
    ast
  end
  
  def string_join(ast)
    strings = ast[1..-1]
    # Make sure there is actually a conversion to do
    return unless strings.any? { |s| s.first == :array }
    # Now work out the largest dimensions
    # Arrays look like this [:array, [:row, 1, 2, 3], [:row, 4, 5, 6]]
    max_rows = 0
    max_columns = 0
    strings.each do |s|
      next unless s.first == :array
      r = s.length - 1 # -1 beause first element is :array
      c = r > 0 ? s[1].length - 1 : 0 # check if rows, if there are, columns is length of that array -1 for initial :row symbol
      max_columns = c if c > max_columns
      max_rows = r if r > max_rows
    end

    result = [:array]
    (0...max_rows).each do |row_index|
      row = [:row]
      (0...max_columns).each do |column_index|
        column = [:string_join]
        strings.each do |string|
          column << select_from(string, row_index, column_index)
        end
        row << column
      end
      result << row
    end
    ast.replace(result)
  end

  def select_from(maybe_array, row_index, column_index)
    return map(maybe_array) unless maybe_array.first == :array
    row = maybe_array[row_index+1]
    return [:error, "#VALUE!"] unless row
    cell = row[column_index+1]
    return [:error, "#VALUE!"] unless cell
    map(cell)
  end
end
