class DoNothing
  include Base

  def to_s
    'Do nothing'
  end

  def ==(other_statement)
    other_statement.instance_of?(DoNothing)
  end
end

class Assignment < Struct.new(:name, :expression)
  include Base

  def to_s
    "#{name} = #{expression}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when expression.reducible?
      [Assignment.new(name, expression.reduce(env)), env]
    else
      [DoNothing.new, env.merge(name => expression)]
    end
  end
end

class If < Struct.new(:condition, :consequence, :alternative)
  include Base

  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when condition.reducible?
      [If.new(condition.reduce(env), consequence, alternative), env]
    when condition == Bool.new(true)
      [consequence, env]
    else
      [alternative, env]
    end
  end
end

class Sequence < Struct.new(:first, :second)
  include Base

  def to_s
    "#{first}; #{second}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case first
    when DoNothing.new
      [second, env]
    else
      reduced_statement, reduced_env = first.reduce(env)
      [Sequence.new(reduced_statement, second), reduced_env]
    end
  end
end

class While < Struct.new(:condition, :body)
  include Base

  def to_s
    "while (#{condition}) { #{body} }"
  end

  def reducible?
    true
  end

  def reduce(env)
    [If.new(condition, Sequence.new(body, self), DoNothing.new), env]
  end
end