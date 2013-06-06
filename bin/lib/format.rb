module Format
  FORMAT_TO_CODE   = {
      :bold      => '1',
      :underline => '4',
  }
  FG_COLOR_TO_CODE = {
      :black  => '30',
      :red    => '31',
      :green  => '32',
      :yellow => '33',
      :blue   => '34',
      :purple => '35',
      :cyan   => '36',
      :white  => '37',
      :none   => nil,
  }
  BG_COLOR_TO_CODE = {
      :black  => '40',
      :red    => '41',
      :green  => '42',
      :yellow => '43',
      :blue   => '44',
      :purple => '45',
      :cyan   => '46',
      :white  => '47',
      :none   => nil,
  }

  def self::format(text, format_code)
    "\e[#{format_code}m#{text}\e[0m"
  end

  def self::build_string(bold, underline, fgcolor, bgcolor)
    str = ''
    hit = false
    if bold
      hit = true
      str = FORMAT_TO_CODE[:bold]
    end
    if underline
      str += ';' if hit
      hit = true
      str += FORMAT_TO_CODE[:underline]
    end
    unless fgcolor.nil? || FG_COLOR_TO_CODE[fgcolor].nil?
      str += ';' if hit
      hit = true
      str += FG_COLOR_TO_CODE[fgcolor]
    end
    unless bgcolor.nil? || BG_COLOR_TO_CODE[bgcolor].nil?
      str += ';' if hit
      str += BG_COLOR_TO_CODE[bgcolor]
    end
    str
  end

  def self::parse_format(str)
    parts     = str.split(';')
    bold      = false
    underline = false
    fgcolor   = :none
    bgcolor   = :none
    parts.each { |v|
      if v == FORMAT_TO_CODE[:bold]
        bold = true
      elsif v == FORMAT_TO_CODE[:underline]
        underline = true
      elsif v[0] == '3'
        fgcolor = FG_COLOR_TO_CODE.invert[v]
      elsif v[0] == '4'
        bgcolor = BG_COLOR_TO_CODE.invert[v]
      end
      return bold, underline, fgcolor, bgcolor
    }
  end

  def self::colorize(text, fgcolor = nil, bgcolor = nil)
    self::format(text, self::build_string(false, false, fgcolor, bgcolor))
  end

  def self::bold(text, fgcolor = nil, bgcolor = nil)
    self::format(text, self::build_string(true, false, fgcolor, bgcolor))
  end

  def self::underline(text, fgcolor = nil, bgcolor = nil)
    self::format(text, self::build_string(false, true, fgcolor, bgcolor))
  end

  def self::boldunderline(text, fgcolor = nil, bgcolor = nil)
    self::format(text, self::build_string(true, true, fgcolor, bgcolor))
  end
end