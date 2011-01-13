# temprerary put here
$alias_hash = {'ls' => 'ls --color=auto'}

module Eggsh
  class Shell

    def initialize
      @pwd = '~'
    end

    def pwd
      short = @pwd.split['/']
      (0...short.size).each {|i| short[i] = short[i][0]}
      return short.join '/'
    end

    def full_pwd
      @pwd
    end

    def exec line
      begin
        if line != '' && $alias_hash.has_key?(line.split(' ')[0])
          splitted = line.split(' ')
          splitted[0] = $alias_hash[splitted[0]]
          line = splitted.join ' '
        end
        #puts line
        system translate(line).gsub("\n", ' ')
      #rescue
      #  puts 'Syntax error'
      end
    end
  end
end

