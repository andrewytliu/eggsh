require_relative 'translator'

# temprerary put here
$alias_hash = {'ls' => 'ls --color=auto'}

module Eggsh
  class Shell
    SHELL_CMD = {'cd' => :cd, 'pwd' => :pwd, 'fullpwd' => :full_pwd,
                 'quit' => :quit, 'exit' => :quit}

    def initialize
      @env = ENV.to_hash
      @pwd = ENV['PWD']
      @translator = Eggsh::Translator.new
    end

    def env
      @env
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
          begin
            spawn(@env, @translator.translate(line).gsub("\n", ' '), :chdir => @pwd)
          rescue Errno::ENOENT => e
            puts e.display
          end
        end
      #rescue
      #  puts 'Syntax error'
      end
    end

  private
    def pwd arg
      short = @pwd.split '/'
      (0...(short.size - 1)).each {|i| short[i] = short[i][0]}
      puts short.join '/'
    end

    def full_pwd arg
      puts @pwd
    end

    def cd arg
      new_path = File.expand_path arg.split(' ')[1], @pwd
      if File.directory? new_path
        @pwd = new_path
      else
        puts "cd: Invalid path #{arg.split(' ')[1]}"
      end
    end

    def quit arg
      exit
    end
  end
end

