require_relative 'shell'
require_relative 'util'
require 'readline'

module Eggsh
  # the path of rc file
  RC_PATH = '~/.eggshrc'

  class Runner
    def initialize
      @shell = Eggsh::Shell.new
      load_rc
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

  private
    # read a single line by readline
    def read
      line = Readline.readline(@shell.prompt, true)
      return nil if line.nil?
      if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
        Readline::HISTORY.pop
      end
      line
    end

    # load rc file from ~/.eggshrc
    def load_rc
      path = File.expand_path RC_PATH
      if File.exist? path
        eval(IO.read path)
      end
    end
  end
end

