require File.expand_path('../translator.rb', __FILE__)

module Eggsh
  class Shell
    include Translator
    # mapping from shell commands to member function
    SHELL_CMD = {'cd' => :cd, 'pwd' => :pwd, 'fullpwd' => :full_pwd,
                 'quit' => :quit, 'exit' => :quit}

    # alias hash for command alias
    ALIAS = {'ls' => 'ls --color=auto'}

    def initialize
      @env = ENV.to_hash
      @pwd = ENV['PWD']
    end

    # generating prompt
    def prompt
      "#{pwd.to_color(:bold_green)}$ "
    end

    # handling a single line
    def exec line
      begin
        # alias first
        if line != '' && ALIAS.has_key?(line.split(' ')[0])
          splitted = line.split(' ')
          splitted[0] = ALIAS[splitted[0]]
          line = splitted.join ' '
        end

        if !line.empty? && SHELL_CMD.has_key?(line.split(' ')[0])
          msg = send(SHELL_CMD[line.split(' ')[0]], line)
          puts msg if msg
        elsif line.empty?
        else
          begin
            shell_line = translate(line)
            forking shell_line unless shell_line.empty?
          rescue Exception => e
            puts e.display
          end
        end
      end
    end

  private
    def forking line
      # FIXME: this is a dirty fix
      if RUBY_VERSION < '1.9'
        system "cd #{@pwd}; #{line}"
      else
        spawn @env, line, :chdir => @pwd
        Process.wait
      end
    end

    def pwd arg = ''
      short = @pwd.sub(/^#{ENV['HOME']}/, '~').split '/'
      (0...(short.size - 1)).each {|i| short[i] = short[i][0..0]}
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

