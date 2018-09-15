class Number < Struct.new(:value)
  include Base

  def to_s
    value.to_s
  end
end

class Bool < Struct.new(:value)
  include Base

  def to_s
    value.to_s
  end
end

class Add < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} + #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      Add.new(left.reduce(env), right)
    when right.reducible?
      Add.new(left, right.reduce(env))
    else
      Number.new(left.value + right.value)
    end
  end
end

class Substract < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} - #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      Substract.new(left.reduce(env), right)
    when right.reducible?
      Substract.new(left, right.reduce(env))
    else
      Number.new(left.value - right.value)
    end
  end
end

class Divide < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} / #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      Divide.new(left.reduce(env), right)
    when right.reducible?
      Divide.new(left, right.reduce(env))
    else
      Number.new(left.value / right.value)
    end
  end
end

class Multiply < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} * #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      Multiply.new(left.reduce(env), right)
    when right.reducible?
      Multiply.new(left, right.reduce(env))
    else
      Number.new(left.value * right.value)
    end
  end
end

class LessThan < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} < #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      LessThan.new(left.reduce(env), right)
    when right.reducible?
      LessThan.new(left, right.reduce(env))
    else
      Bool.new(left.value < right.value)
    end
  end
end

class Equal < Struct.new(:left, :right)
  include Base

  def to_s
    "#{left} == #{right}"
  end

  def reducible?
    true
  end

  def reduce(env)
    case
    when left.reducible?
      Equal.new(left.reduce(env), right)
    when right.reducible?
      Equal.new(left, right.reduce(env))
    else
      Bool.new(left.value == right.value)
    end
  end
end


class Variable < Struct.new(:name)
  include Base

  def to_s
    name.to_s
  end

  def reducible?
    true
  end

  def reduce(env)
    env[name]
  end
end
