class Object
  # define to_cmd for every object
  def to_cmd
    if self.kind_of? Array
      return self.join ' '
    else
      return self.to_s
    end
  end

  # color code for colorful terminal output
  COLOR_CODE = {
    :black => '30', :red => '31', :green => '32', :yellow => '33', :blue => '34',
    :purple => '35', :cyan => '36', :white => '37', :bold_black => '1;30',
    :bold_red => '1;31', :bold_green => '1;32', :bold_yellow => '1;33',
    :bold_blue => '1;34', :bold_purple => '1;35', :bold_cyan => '1;36',
    :bold_white => '1;37'
  }

  # define to_color for terminal output
  def to_color color
    "\x1b[#{COLOR_CODE[color]}m#{to_s}\x1b[m"
  end
end

