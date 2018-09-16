require './simple_computar/rulebook'

rulebook = DFARulebook.new([
  FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
  FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
  FARule.new(3, 'a', 3), FARule.new(3, 'b', 3),
])

puts rulebook
puts rulebook.next_state(1, 'a')

dfa = DFA.new(1, [3], rulebook)

puts dfa.accepting?
dfa.read_character('a')
puts dfa.accepting?
dfa.read_character('b')
puts dfa.accepting?

p :NFA

rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
  FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
  FARule.new(3, 'a', 4), FARule.new(3, 'b', 4),
])

puts rulebook.next_states([1], 'a')

nfa_design = NFADesign.new(1, [4], rulebook)

puts nfa_design.accepts?('aaba')
puts nfa_design.accepts?('abba')
puts nfa_design.accepts?('bbbb')
puts nfa_design.accepts?('bab')

p :free_move

rulebook = NFARulebook.new([
  FARule.new(1, nil, 2), FARule.new(1, nil, 4),
  FARule.new(2, 'a', 3), FARule.new(3, 'a', 2),
  FARule.new(4, 'a', 5), FARule.new(5, 'a', 6), FARule.new(6, 'a', 4),
])

nfa_design = NFADesign.new(1, [2, 4], rulebook)

puts nfa_design.accepts?('a')
puts nfa_design.accepts?('aa')
puts nfa_design.accepts?('aaa')
puts nfa_design.accepts?('aaaaa')

puts pattern = Repeat.new(
  Choose.new(
    Choose.new(
      Concatenate.new(Literal.new('a'), Literal.new('b')),
      Literal.new('a'),
    ),
    Literal.new('a'),
  )
)