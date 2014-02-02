class ExcelToCode
  def self.version() "0.2.11" end
end

require_relative 'commands'
require_relative 'compile'
require_relative 'excel'
require_relative 'extract'
require_relative 'rewrite'
require_relative 'simplify'
require_relative 'util'
