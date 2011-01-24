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

    def prompt
      "#{pwd.to_color(:bold_green)}$ "
    end

    def exec line
      begin
        # alias first
        if line != '' && $alias_hash.has_key?(line.split(' ')[0])
          splitted = line.split(' ')
          splitted[0] = $alias_hash[splitted[0]]
          line = splitted.join ' '
        end

        if !line.empty? && SHELL_CMD.has_key?(line.split(' ')[0])
          msg = send(SHELL_CMD[line.split(' ')[0]], line)
          puts msg if msg
        elsif line.empty?
        else
          begin
            spawn(@env, @translator.translate(line).gsub("\n", ' '), :chdir => @pwd)
            Process.wait
          rescue Errno::ENOENT => e
            puts e.display
          end
        end
      end
    end

  private
    def pwd arg = ''
      short = @pwd.split '/'
      (0...(short.size - 1)).each {|i| short[i] = short[i][0]}
      short.join '/'
    end

    def full_pwd arg = ''
      @pwd
    end

    def cd arg = '.'
      new_path = File.expand_path arg.split(' ')[1], @pwd
      if File.directory? new_path
        @pwd = new_path
        return nil
      else
        return "cd: Invalid path #{arg.split(' ')[1]}"
      end
    end

    def quit arg = ''
      exit
    end
  end
end

