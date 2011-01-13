require 'shell'
require 'readline'
require 'util'

module Eggsh
  class Runner
    def initialize
      @shell = Eggsh::Shell.new
    end

    def run!
      Readline.completion_append_character = " "
      Readline.completion_proc = Readline::FILENAME_COMPLETION_PROC
      Readline.basic_word_break_characters = ''

      while line = read
        if line =~ /^(?<p>[^\{\}]*(\{\g<p>*\})*)*$/
          @shell.exec line
        else
          puts 'Unbalanced parentheses.'
        end
      end
    end

    def read
      line = Readline.readline('> ', true)
      return nil if line.nil?
      if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
        Readline::HISTORY.pop
      end
      line
    end
  end
end

