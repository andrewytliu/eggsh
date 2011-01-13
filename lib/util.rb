# define to_cmd for every object
class Object
  def to_cmd
    if self.kind_of? Array
      return self.join ' '
    else
      return self.to_s
    end
  end
end

