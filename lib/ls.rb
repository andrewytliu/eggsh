module Eggsh
  class Ls < Array
    alias_method :old_bracket, :[]

    def initialize(arg = nil)
      if arg
        super(arg)
      else
        super(Dir['*'])
      end
    end

    def [] arg
      if arg.kind_of? String
        Dir[arg]
      else
        old_bracket arg
      end
    end
  end
end

