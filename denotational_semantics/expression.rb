require './big_step/expression'

class Number
  def to_ruby
    "-> (e) { #{value} }"
  end
end

class Bool
  def to_ruby
    "-> (e) { #{value} }"
  end
end

class Add
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) + #{right.to_ruby}.call(e) }"
  end
end

class Substract
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) - #{right.to_ruby}.call(e) }"
  end
end

class Divide
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) / #{right.to_ruby}.call(e) }"
  end
end

class Multiply
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) * #{right.to_ruby}.call(e) }"
  end
end

class LessThan
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) < #{right.to_ruby}.call(e) }"
  end
end

class Equal
  def to_ruby
    "-> (e) { #{left.to_ruby}.call(e) == #{right.to_ruby}.call(e) }"
  end
end

class Variable
  def to_ruby
    "-> (e) { e[#{name.inspect}] }"
  end
end
