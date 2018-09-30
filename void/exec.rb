puts -> (x) { x + 2 }.(2)
puts ->(x, y) { x + y }.(3, 4)
puts -> x {
  -> y {
    x + y
  }
}.(3).(4)

p = -> n { n * 2 }
q = -> n { p.(n) }
puts p.(3), q.(3)

puts -> x { x * 5 }[6]

(1..100).each do |n|
  if (n % 15).zero?
    puts 'FizzBuzz'
  elsif (n % 3).zero?
    puts 'Fizz'
  elsif (n % 5).zero?
    puts 'Buzz'
  else
    puts n.to_s
  end
end


r = (1..100).map do |n|
  if (n % 15).zero?
    'FizzBuzz'
  elsif (n % 3).zero?
    'Fizz'
  elsif (n % 5).zero?
    'Buzz'
  else
    n.to_s
  end
end

ZERO = -> p { -> x { x } }
ONE = -> p { -> x { p[x] } }
TWO = -> p { -> x { p[p[x]] } }
THREE = -> p { -> x { p[p[p[x]]] } }
FIVE = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }

def to_integer(proc)
  proc[-> n { n + 1 }][0]
end

p to_integer(ZERO)
p to_integer(ONE)
p to_integer(THREE)
p to_integer(FIVE)
p to_integer(FIFTEEN)
p to_integer(HUNDRED)

def true(x, y)
  x
end

def false(x, y)
  y
end

p send(:true, 'happy', 'sad')
p send(:false, 'happy', 'sad')

TRUE = -> x { -> y { x } }
FALSE = -> x { -> y { y } }

def to_bool(proc)
  proc[true][false]
end

p to_bool(TRUE)
p to_bool(FALSE)

def if(proc, x, y)
  proc[x][y]
end

IF = -> b { -> x { -> y { b[x][y] } } }

p IF[TRUE]['happy']['sad']
p IF[FALSE]['happy']['sad']

def to_bool(proc)
  IF[proc][true][false]
end

p to_bool(TRUE)
p to_bool(FALSE)

IF = -> b { b }

p IF[TRUE]['happy']['sad']
p IF[FALSE]['happy']['sad']

p 'is_zero'

IS_ZERO = -> n { n[-> x { FALSE }][TRUE] }
p to_bool(IS_ZERO[ZERO])
p to_bool(IS_ZERO[ONE])

PAIR = -> x { -> y { -> f { f[x][y] } } }
LEFT = -> p { p[-> x { -> y { x } }] }
RIGHT = -> p { p[-> x { -> y { y } }] }

pair = PAIR[ONE][THREE]

p to_integer(LEFT[pair])
p to_integer(RIGHT[pair])

INCREMENT = -> n { -> p { -> x { p[n[p][x]] } } }

p to_integer(INCREMENT[ONE])
p to_integer(INCREMENT[ZERO])

p 'slide'

SLIDE = -> n { PAIR[RIGHT[n]][INCREMENT[RIGHT[n]]] }

p to_integer(LEFT[SLIDE[ONE]])
p to_integer(RIGHT[SLIDE[ONE]])

DECREMENT = -> n { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }

p to_integer(DECREMENT[ONE])
p to_integer(DECREMENT[TWO])

ADD = -> m { -> n { n[INCREMENT][m] } }
SUBTRACT = -> m { -> n { n[DECREMENT][m] } }
MULTIPLY = -> m { -> n { n[ADD[m]][ZERO] } }
POWER = -> m { -> n { n[MULTIPLY[m]][ONE] } }

p to_integer(ADD[TWO][THREE])
p to_integer(SUBTRACT[THREE][TWO])
p to_integer(MULTIPLY[THREE][TWO])
p to_integer(POWER[THREE][THREE])

IS_LESS_THAN_EQUAL = -> m { -> n { IF[IS_ZERO[SUBTRACT[m][n]]] } }

p to_bool(IS_LESS_THAN_EQUAL[ONE][ONE])
p to_bool(IS_LESS_THAN_EQUAL[ONE][TWO])
p to_bool(IS_LESS_THAN_EQUAL[TWO][ONE])

MOD = -> m { -> n {
  IF[IS_LESS_THAN_EQUAL[n][m]][
    -> x {
      MOD[SUBTRACT[m][n]][n][x]
    }
  ][
    m
  ]
} }

p to_integer(MOD[THREE][TWO])
p to_integer(MOD[MULTIPLY[THREE][TWO]][TWO])

p 'z combi'

Z = -> f { -> x { f[-> y { x[x][y] }] }[-> x { f[-> y { x[x][y] }] }] }

MOD =
  Z[
    -> f {
      -> m { -> n {
        IF[IS_LESS_THAN_EQUAL[n][m]][
          -> x {
            f[SUBTRACT[m][n]][n][x]
          }
        ][
          m
        ]
      } }
    }
  ]

p to_integer(MOD[THREE][TWO])
p to_integer(MOD[MULTIPLY[THREE][TWO]][TWO])

EMPTY = PAIR[TRUE][TRUE]
UNSHIFT = -> l { -> x { PAIR[FALSE][PAIR[x][l]] } }
IS_EMPTY = LEFT
FIRST = -> l { LEFT[RIGHT[l]] }
REST = -> l { RIGHT[RIGHT[l]] }

my_list = UNSHIFT[
  UNSHIFT[
    UNSHIFT[EMPTY][THREE]
  ][TWO]
][ONE]

p to_integer(FIRST[my_list])
p to_integer(FIRST[REST[my_list]])
p to_bool(IS_EMPTY[my_list])
p to_bool(IS_EMPTY[EMPTY])

def to_array(proc)
  array = []

  until to_bool(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end

  array
end

p to_array(my_list)
p to_array(my_list).map { |n| to_integer(n) }

RANGE =
  Z[
    -> f {
      -> m { -> n {
        IF[IS_LESS_THAN_EQUAL[m][n]][
          -> x {
            UNSHIFT[f[INCREMENT[m]][n]][m][x]
          }
        ][
          EMPTY
        ]
      } }
    }
  ]

p my_range = RANGE[ONE][FIVE]
p to_array(my_range).map { |n| to_integer(n) }

FOLD =
  Z[
    -> f {
      -> l { -> x { -> g {
        IF[IS_EMPTY[l]][
          x
        ][
          -> y {
            g[f[REST[l]][x][g]][FIRST[l]][y]
          }
        ]
      } } }
    }
  ]

p to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD])
p to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY])

MAP =
  -> k { -> f {
    FOLD[k][EMPTY][
      -> l { -> x { UNSHIFT[l][f[x]] } }
    ]
  } }

p my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
p to_array(my_list).map { |n| to_integer(n) }

TEN = MULTIPLY[TWO][FIVE]
B = TEN
F = INCREMENT[B]
I = INCREMENT[F]
U = INCREMENT[I]
ZED = INCREMENT[U]

FIZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][I]][F]
BUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][U]][B]
FIZZBUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[BUZZ][ZED]][ZED]][I]][F]

def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end

p to_char(ZED)
p to_string(FIZZ)
p to_string(BUZZ)
p to_string(FIZZBUZZ)

DIV =
  Z[
    -> f {
      -> m { -> n {
        IF[IS_LESS_THAN_EQUAL[n][m]][
          -> x {
            INCREMENT[f[SUBTRACT[m][n]][n]][x]
          }
        ][
          ZERO
        ]
      } }
    }
  ]

p to_integer(DIV[TEN][TWO])

PUSH =
  -> l {
    -> x {
      FOLD[l][UNSHIFT[EMPTY][x]][UNSHIFT]
    }
  }

my_list = PUSH[RANGE[ONE][FIVE]][TEN]
p to_array(my_list).map { |n| to_integer(n) }

TO_DIGITS =
  Z[
    -> f {
      -> n {
        PUSH[
          IF[IS_LESS_THAN_EQUAL[n][DECREMENT[TEN]]][
            EMPTY
          ][
            -> x {
              f[DIV[n][TEN]][x]
            }
          ]
        ][MOD[n][TEN]]
      }
    }
  ]

p to_array(TO_DIGITS[FIVE]).map { |n| to_integer(n) }
p to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |n| to_integer(n) }.join
p to_string(TO_DIGITS[FIVE])
p to_string(TO_DIGITS[POWER[FIVE][THREE]])

solution = MAP[RANGE[ONE][HUNDRED]][-> n {
  IF[IS_ZERO[MOD[n][FIFTEEN]]][
    FIZZBUZZ
  ][IF[IS_ZERO[MOD[n][THREE]]][
    FIZZ
  ][IF[IS_ZERO[MOD[n][FIVE]]][
    BUZZ
  ][
    TO_DIGITS[n]
  ]]]
}]

to_array(solution).each do |p|
  p to_string(p)
end