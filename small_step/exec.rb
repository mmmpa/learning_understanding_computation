require './machine'
require './expression'
require './statement'

env = {
  one: Number.new(1),
  two: Number.new(2),
}

a = Add.new(
  Number.new(3),
  Multiply.new(
    Number.new(2),
    Number.new(4),
  )
)

b = Equal.new(
  Number.new(3),
  Number.new(4),
)

c = Divide.new(
  Variable.new(:one),
  Variable.new(:two),
)

Machine.new(a, env).exec
Machine.new(b, env).exec
Machine.new(c, env).exec

StatementMachine.new(
  Assignment.new(:x, Number.new(13)),
  env,
).exec

StatementMachine.new(
  If.new(
    Equal.new(Variable.new(:one), Number.new(1)),
    Assignment.new(:x, Number.new(1)),
    Assignment.new(:x, Number.new(2)),
  ),
  env,
).exec

StatementMachine.new(
  If.new(
    Equal.new(Variable.new(:one), Number.new(2)),
    Assignment.new(:x, Number.new(1)),
    Assignment.new(:x, Number.new(2)),
  ),
  env,
).exec


StatementMachine.new(
  Sequence.new(
    Assignment.new(:z, Number.new(1)),
    Assignment.new(:zz, Number.new(2)),
  ),
  env,
).exec

StatementMachine.new(
  While.new(
    LessThan.new(Variable.new(:one), Number.new(10)),
    Assignment.new(:one, Add.new(Variable.new(:one), Number.new(1))),
  ),
  env,
).exec
