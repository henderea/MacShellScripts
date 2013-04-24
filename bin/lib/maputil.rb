module Enumerable
  def filtermap(&block)
    map(&block).select { |i| i }
  end
end