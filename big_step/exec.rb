require './big_step/expression'
require './big_step/statement'

puts Add.new(
  Number.new(2),
  Number.new(3),
).evaluate({})

puts If.new(
  Equal.new(
    Number.new(2),
    Number.new(3)
  ),
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:x, Number.new(2)),
).evaluate({})

puts If.new(
  Equal.new(
    Number.new(3),
    Number.new(3)
  ),
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:x, Number.new(2)),
).evaluate({})


puts Sequence.new(
  Assignment.new(:x, Number.new(1)),
  Assignment.new(:y, Number.new(2)),
).evaluate({})


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
).evaluate({ x: Number.new(0) })
