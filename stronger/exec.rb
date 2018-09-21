require './stronger/machine'

stack = Stack.new(%w(a b c d))

p stack
p stack.top
p stack.pop.top
p stack.push('z').top

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
configuration = PDAConfiguration.new(1, Stack.new(['$']))

p rule.applies_to?(configuration, '(')
p rule.applies_to?(configuration, ')')

stack = Stack.new(['$']).push('x').push('y').push('z')
p stack.top
p stack = stack.pop
p stack = stack.pop
p stack = stack.pop

rulebook = DPDARulebook.new([
  PDARule.new(1, '(', 2, '$', ['b', '$']),
  PDARule.new(2, '(', 2, 'b', ['b', 'b']),
  PDARule.new(2, ')', 2, 'b', []),
  PDARule.new(2, nil, 1, '$', ['$']),
])

p configuration = rulebook.next_configuration(configuration, '(')
p configuration = rulebook.next_configuration(configuration, '(')
p configuration = rulebook.next_configuration(configuration, '(')
p configuration = rulebook.next_configuration(configuration, ')')
p configuration = rulebook.next_configuration(configuration, ')')
p configuration = rulebook.next_configuration(configuration, ')')

p rulebook.follow_free_moves(configuration)

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)

p dpda.accepting?
dpda.read_string('(')
p dpda.accepting?
dpda.read_string(')')
p dpda.accepting?
dpda.read_string('(((())))')
p dpda.accepting?
dpda.read_string('()()(((())))')
p dpda.accepting?

dd = DPDADesign.new(1, '$', [1], rulebook)
p dd.accepts?('(')
p dd.accepts?('()()')
p dd.accepts?('((())()(())')

p dd.accepts?('())()')

dd = DPDADesign.new(1, '$', [1], DPDARulebook.new([
  PDARule.new(1, 'a', 2, '$', ['a', '$']),
  PDARule.new(1, 'b', 2, '$', ['b', '$']),
  PDARule.new(2, 'a', 2, 'a', ['a', 'a']),
  PDARule.new(2, 'b', 2, 'b', ['b', 'b']),
  PDARule.new(2, 'a', 2, 'b', []),
  PDARule.new(2, 'b', 2, 'a', []),
  PDARule.new(2, nil, 1, '$', ['$']),
]))
p dd.accepts?('aabbab')
p dd.accepts?('ab')
p dd.accepts?('aba')

p :m

dd = DPDADesign.new(1, '$', [4], DPDARulebook.new([
  PDARule.new(1, 'a', 2, '$', ['a', '$']),
  PDARule.new(1, 'b', 2, '$', ['b', '$']),
  PDARule.new(2, 'a', 2, 'a', ['a', 'a']),
  PDARule.new(2, 'b', 2, 'b', ['b', 'b']),
  PDARule.new(2, 'a', 2, 'b', ['a', 'b']),
  PDARule.new(2, 'b', 2, 'a', ['b', 'a']),
  PDARule.new(2, 'm', 3, 'a', ['a']),
  PDARule.new(2, 'm', 3, 'b', ['b']),
  PDARule.new(3, 'a', 3, 'a', []),
  PDARule.new(3, 'b', 3, 'b', []),
  PDARule.new(3, nil, 4, '$', ['$']),
]))
p dd.accepts?('abmba')
p dd.accepts?('amb')
p dd.accepts?('abamaba')

p :npda

rulebook = NPDARulebook.new([
  PDARule.new(1, 'a', 1, '$', ['a', '$']),
  PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
  PDARule.new(1, 'a', 1, 'b', ['a', 'b']),

  PDARule.new(1, 'b', 1, '$', ['b', '$']),
  PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
  PDARule.new(1, 'b', 1, 'b', ['b', 'b']),

  PDARule.new(1, nil, 2, '$', ['$']),
  PDARule.new(1, nil, 2, 'a', ['a']),
  PDARule.new(1, nil, 2, 'b', ['b']),

  PDARule.new(2, 'a', 2, 'a', []),
  PDARule.new(2, 'b', 2, 'b', []),

  PDARule.new(2, nil, 3, '$', ['$']),
])

npda = NPDADesign.new(1, '$', [3], rulebook)
p npda.accepts?('aba')
p npda.accepts?('aabaaa')
p npda.accepts?('baab')
p npda.accepts?('baaab')
p npda.accepts?('abba')
p npda.accepts?('abbba')

p :lexical

p LexicalAnalyzer.new('y = x * 7').analyze
p LexicalAnalyzer.new('while (x < 10) { x = x * 3}').analyze
p LexicalAnalyzer.new('if (x < 10) { y = true; x = 0 } else { do-nothing }').analyze

symbol_rules = [
  PDARule.new(2, nil, 2, 'S', ['W']),
  PDARule.new(2, nil, 2, 'S', ['A']),

  PDARule.new(2, nil, 2, 'W', %w[w ( E ) { S }]),
  PDARule.new(2, nil, 2, 'A', %w[v = E]),
  PDARule.new(2, nil, 2, 'E', %w[L]),

  PDARule.new(2, nil, 2, 'L', %w[M < L]),
  PDARule.new(2, nil, 2, 'L', %w[M]),

  PDARule.new(2, nil, 2, 'M', %w[T * M]),
  PDARule.new(2, nil, 2, 'M', %w[T]),

  PDARule.new(2, nil, 2, 'T', %w[n]),
  PDARule.new(2, nil, 2, 'T', %w[v]),
]
tokens_rules = LexicalAnalyzer::GRAMMAR.map do |rule|
  PDARule.new(2, rule[:token], 2, rule[:token], [])
end
start_rule = PDARule.new(1, nil, 2, '$', %w[S $])
stop_rule = PDARule.new(2, nil, 3, '$', %w[$])

rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + tokens_rules)
npda = NPDADesign.new(1, '$', [3], rulebook)

p token_string = LexicalAnalyzer.new('while (x < 10) { x = x * 3}').analyze.join
p npda.accepts?(token_string)
p npda.accepts?(token_string + ')')
