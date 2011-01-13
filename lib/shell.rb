require_relative 'translator'

# temprerary put here
$alias_hash = {'ls' => 'ls --color=auto'}

module Eggsh
  class Shell
    SHELL_CMD = {'cd' => :cd, 'pwd' => :pwd, 'fullpwd' => :full_pwd}

    def initialize
      @pwd = ENV['PWD']
      @translator = Eggsh::Translator.new
    end

    def pwd arg
      short = @pwd.split['/']
      (0...short.size).each {|i| short[i] = short[i][0]}
      puts short.join '/'
    end

    def full_pwd arg
      puts @pwd
    end

    def cd arg
      new_path = @pwd + arg.split(' ')[1]
      if File.directory? new_path
        @pwd = new_path
        ENV['PATH'] = new_path
      else
        puts 'Invalid path'
      end
    end

    def exec line
      begin
        # alias first
        if line != '' && $alias_hash.has_key?(line.split(' ')[0])
          splitted = line.split(' ')
          splitted[0] = $alias_hash[splitted[0]]
          line = splitted.join ' '
        end
        #puts line
        if line != '' && SHELL_CMD.has_key?(line.split(' ')[0])
          send(SHELL_CMD[line.split(' ')[0]], line)
        else
          system @translator.translate(line).gsub("\n", ' ')
        end
      #rescue
      #  puts 'Syntax error'
      end
    end
  end
end

