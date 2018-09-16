require './denotational_semantics/expression'
require './denotational_semantics/statement'
require 'treetop'
Treetop.load('simple')

class String
  def call(e)
    eval(self).call(e)
  end
end

puts Number.new(2).to_ruby.call({})

puts Add.new(
  Number.new(2),
  Number.new(3),
).to_ruby.call({})

puts If.new(
  Equal.new(
    Number.new(2),
    Number.new(3)
  ),
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:x, Number.new(2)),
).to_ruby.call({})

puts If.new(
  Equal.new(
    Number.new(3),
    Number.new(3)
  ),
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:x, Number.new(2)),
).to_ruby.call({})


puts Sequence.new(
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:y, Number.new(2)),
).to_ruby.call({})


puts While.new(
  LessThan.new(
    Variable.new(:x),
    Number.new(20)
  ),
  Assignment.new(
    :x,
    Add.new(
      Variable.new(:x),
      Number.new(1),
    )
  ),
).to_ruby.call({ x: 0 })

p SimpleParser.new.parse('while (x < 5) { x = x + 1 }').to_ast .to_ruby.call({ x: 0 })