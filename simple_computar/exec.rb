require './simple_computar/rulebook'
require 'treetop'
Treetop.load('pattern')

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

p :matches

puts Literal.new('a').matches?('a')
puts Empty.new.matches?('')
puts Concatenate.new(Literal.new('a'), Literal.new('b')).matches?('ab')
puts Concatenate.new(Literal.new('a'), Literal.new('b')).matches?('abc')
puts Choose.new(Literal.new('a'), Literal.new('b')).matches?('a')
puts Choose.new(Literal.new('a'), Literal.new('b')).matches?('b')
puts Choose.new(Literal.new('a'), Literal.new('b')).matches?('c')
puts Repeat.new(Concatenate.new(Literal.new('a'), Literal.new('b'))).matches?('ab')
puts Repeat.new(Concatenate.new(Literal.new('a'), Literal.new('b'))).matches?('')

puts PatternParser.new.parse('ab').to_ast.matches?('ab')


rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2),
  FARule.new(2, 'b', 3),
  FARule.new(3, 'b', 1), FARule.new(3, nil, 2),
])

nfa_design = NFADesign.new(1, [3], rulebook)

p nfa_design.to_nfa.current_states
p nfa_design.to_nfa(Set[2]).current_states
p nfa_design.to_nfa(Set[3, 2]).current_states

nfa = nfa_design.to_nfa(Set[2, 3])
nfa.read_character('b')
p nfa.current_states

sim = NFASimulation.new(nfa_design)
p sim.next_state(Set[3, 4], 'b')

p rulebook.alphabet
p sim.rules_for(Set[1, 2])

start_states = nfa_design.to_nfa.current_states
p sim.discover_states_and_rules(Set[start_states])
dfa_design = sim.to_dfa_design

p dfa_design.accepts?('aaa')
p dfa_design.accepts?('aab')
