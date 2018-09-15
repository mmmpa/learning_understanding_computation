module Base
  def inspect
    "<<#{self}>>"
  end

  def reducible?
    false
  end
end

class Machine < Struct.new(:expression, :env)
  def step
    self.expression = expression.reduce(env)
  end

  def exec
    while expression.reducible?
      puts expression
      step
    end
    puts expression
  end
end

class StatementMachine < Struct.new(:statement, :env)
  def step
    self.statement, self.env = statement.reduce(env)
  end

  def exec
    while statement.reducible?
      puts statement, env
      step
    end
    puts statement, env
  end
end
