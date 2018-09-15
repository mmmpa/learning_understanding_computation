require './small_step/expression'

class Number
  def evaluate(env)
    self
  end
end

class Bool
  def evaluate(env)
    self
  end
end

class Add
  def evaluate(env)
    Number.new(left.evaluate(env).value + right.evaluate(env).value)
  end
end

class Substract
  def evaluate(env)
    Number.new(left.evaluate(env).value - right.evaluate(env).value)
  end
end

class Divide
  def evaluate(env)
    Number.new(left.evaluate(env).value / right.evaluate(env).value)
  end
end

class Multiply
  def evaluate(env)
    Number.new(left.evaluate(env).value * right.evaluate(env).value)
  end
end

class LessThan
  def evaluate(env)
    Bool.new(left.evaluate(env).value < right.evaluate(env).value)
  end
end

class Equal
  def evaluate(env)
    Bool.new(left.evaluate(env).value == right.evaluate(env).value)
  end
end

class Variable
  def evaluate(env)
    env[name]
  end
end
