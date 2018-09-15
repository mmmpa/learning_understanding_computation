require './small_step/statement'

class DoNothing
  def evaluate(env)
    env
  end
end

class Assignment
  def evaluate(env)
    env.merge(name => expression.evaluate(env))
  end
end

class If
  def evaluate(env)
    case condition.evaluate(env)
    when Bool.new(true)
      consequence.evaluate(env)
    else
      alternative.evaluate(env)
    end
  end
end

class Sequence
  def evaluate(env)
    second.evaluate(first.evaluate(env))
  end
end

class While
  def evaluate(env)
    case condition.evaluate(env)
    when Bool.new(true)
      evaluate(body.evaluate(env))
    else
      env
    end
  end
end
