require File.expand_path('../ls.rb', __FILE__)

module Eggsh
  module Translator
    # TODO: make %| |, %< >, %( ) syntax possible
    # translate a certain line with ruby expression
    def translate line
      eval_str, result, count = "", "", 0
      for i in line.split ''
        count += 1 if i == '{'
        if count == 0
          result += eval_part(eval_str).to_cmd + i
          eval_str = ''
        else
          eval_str += i
        end
        count -= 1 if i == '}'
      end
      result += eval_part(eval_str).to_cmd
      raise 'eggsh: Unbalanced parenthesis' if count != 0
      result
    end

  private
    def eval_part line
      return '' if line.empty?
      ls = Eggsh::Ls.new
      if line =~ /\{\??(.*)\}/
        str = eval($1) unless line.empty?
        if line =~ /\{\?(.*)\}/
          return nil
        else
          return str
        end
      else
        line
      end
    end
  end
end

