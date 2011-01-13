require 'ls'

module Eggsh
  class Translator
    def translate line
      ls = Eggsh::Ls.new

      nested = /(\{[^\{\}]*\})/
      if line =~ nested
        translate(line.sub(nested, eval($1[1..-2]).to_cmd))
      else
        line
      end
    end
  end
end

