$LOAD_PATH << File.dirname(__FILE__)

require 'maputil'

module Enumerable
  def histogram(ks = nil, width = 100, height = 50)
    mi     = min
    ma     = max
    diff   = ma - mi
    step   = diff.to_f / width.to_f
    counts = Array.new(width, 0)
    each { |v|
      i         = ((v - mi).to_f / (step + 1).to_f).floor
      counts[i] += 1
    }
    max_y = counts.max
    lines = Array.new(height) { ' ' * width }
    (0...width).each { |i|
      h = ((counts[i].to_f / max_y.to_f) * height.to_f).round
      ((height - h)...height).each { |j|
        lines[j][i] = '#'
      }
    }
    unless ks.nil?
      lines[height] = ' ' * width
      ks.each { |v|
        i                = ((v - mi) / step).to_i
        lines[height][i] = '|'
      }
    end
    lines
  end
end