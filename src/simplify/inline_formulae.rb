class InlineFormulaeAst
  
  attr_accessor :references, :current_sheet_name, :inline_ast
  
  def initialize(references, current_sheet_name, inline_ast = nil)
    @references, @current_sheet_name, @inline_ast = references, [current_sheet_name], inline_ast
    @inline_ast ||= lambda { |sheet,reference,references| true }
  end
  
  def map(ast)
    return ast unless ast.is_a?(Array)
    operator = ast[0]
    if respond_to?(operator)
      send(operator,*ast[1..-1])
    else
      [operator,*ast[1..-1].map {|a| map(a) }]
    end
  end
  
  def sheet_reference(sheet,reference)
    if inline_ast.call(sheet,reference.last.upcase.gsub('$',''),references)
      ast = references[sheet][reference.last.upcase.gsub('$','')]
      if ast
        current_sheet_name.push(sheet)
        result = map(ast)
        current_sheet_name.pop
      else
        result = [:blank]
      end
    else
      result = [:sheet_reference,sheet,reference]
    end
    result
  end
  
  # TODO: Optimize by replacing contents of references hash with the inlined version
  def cell(reference)
    if inline_ast.call(current_sheet_name.last,reference.upcase.gsub('$',''),references)
      ast = references[current_sheet_name.last][reference.upcase.gsub('$','')]
      if ast
        map(ast)
      else
        [:blank]
      end
    else
      if current_sheet_name.size > 1
        [:sheet_reference,current_sheet_name.last,[:cell,reference]]
      else
        [:cell,reference]
      end
    end
  end
    
end
  

class InlineFormulae
  
  attr_accessor :references, :default_sheet_name, :inline_ast
  
  def self.replace(*args)
    self.new.replace(*args)
  end
  
  def replace(input,output)
    rewriter = InlineFormulaeAst.new(references, default_sheet_name, inline_ast)
    input.each_line do |line|
      # Looks to match lines with references
      if line =~ /\[:cell/
        ref, ast = line.split("\t")
        output.puts "#{ref}\t#{rewriter.map(eval(ast)).inspect}"
      else
        output.puts line
      end
    end
  end
end
