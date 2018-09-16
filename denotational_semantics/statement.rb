require './big_step/statement'

class DoNothing
  def to_ruby
    "-> (e) { e }"
  end
end

class Assignment
  def to_ruby
    "-> (e) { e.merge(#{name.inspect} => #{expression.to_ruby}.call(e)) }"
  end
end

class If
  def to_ruby
    "-> (e) {
      if #{condition.to_ruby}.call(e)
        #{consequence.to_ruby}.call(e)
      else
        #{alternative.to_ruby}.call(e)
      end
    }"
  end
end

class Sequence
  def to_ruby
    "-> (e) { #{second.to_ruby}.call(#{first.to_ruby}.call(e)) }"
  end
end

class While
  def to_ruby
    "-> (e) {
      while #{condition.to_ruby}.call(e)
        e = #{body.to_ruby}.call(e)
      end
      e
    }"
  end
end
