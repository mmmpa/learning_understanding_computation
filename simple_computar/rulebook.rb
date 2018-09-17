require 'set'
require 'pp'

class FARule < Struct.new(:state, :character, :next_state)
  def applies_to?(state, character)
    self.state == state && self.character == character
  end

  def follow
    next_state
  end

  def inspect
    "#<FARule #{state.inspect} --#{character}--> #{next_state.inspect}>"
  end
end

class DFARulebook < Struct.new(:rules)
  def next_state(state, character)
    rule_for(state, character).follow
  end

  def rule_for(state, character)
    rules.detect { |rule| rule.applies_to?(state, character) }
  end
end

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_state)
  end

  def read_character(character)
    self.current_state = rulebook.next_state(current_state, character)
  end
end

class NFARulebook < Struct.new(:rules)
  def next_states(states, character)
    states.flat_map { |state| rules_for(state, character) }.to_set
  end

  def follow_rules_for(state, character)
    rules.select { |rule| rule.applies_to?(state, character) }
  end

  def rules_for(state, character)
    follow_rules_for(state, character).map(&:follow)
  end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
  def accepting?
    (current_states & accept_states).any?
  end

  def read_character(character)
    self.current_states = rulebook.next_states(current_states, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
  def accepts?(string)
    to_nfa.tap { |nfa| nfa.read_string(string) }.accepting?
  end

  def to_nfa
    NFA.new(Set[start_state], accept_states, rulebook)
  end
end

class NFARulebook
  def follow_free_moves(states)
    more_states = next_states(states, nil)

    if more_states.subset?(states)
      states
    else
      follow_free_moves(states + more_states)
    end
  end
end

class NFA
  def current_states
    rulebook.follow_free_moves(super)
  end
end

module Pattern
  def brancket(outer_precedence)
    if precedence < outer_precedence
      "(#{to_s})"
    else
      to_s
    end
  end

  def inspect
    "/#{self}/"
  end
end

class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end
end

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end

  def precedence
    3
  end
end

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.brancket(precedence) }.join
  end

  def precedence
    1
  end
end

class Choose < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map { |pattern| pattern.brancket(precedence) }.join('|')
  end

  def precedence
    0
  end
end


class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    pattern.brancket(precedence) + '*'
  end

  def precedence
    2
  end
end

module Pattern
  def matches?(string)
    to_nfm.accepts?(string)
  end
end


class Empty
  def to_nfm
    start_state = Object.new
    accept_states = [start_state]
    rulebook = NFARulebook.new([])

    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Literal
  def to_nfm
    start_state = Object.new
    accept_state = Object.new
    accept_states = [accept_state]
    rulebook = NFARulebook.new([
      FARule.new(start_state, character, accept_state),
    ])

    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Concatenate
  def to_nfm
    first_nfm = first.to_nfm
    second_nfm = second.to_nfm

    start_state = first_nfm.start_state
    accept_states = second_nfm.accept_states
    rulebook = NFARulebook.new(
      first_nfm.rulebook.rules + second_nfm.rulebook.rules + (first_nfm.accept_states.map do |accept_state|
        FARule.new(accept_state, nil, second_nfm.start_state)
      end)
    )

    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Choose
  def to_nfm
    first_nfm = first.to_nfm
    second_nfm = second.to_nfm

    start_state = Object.new
    accept_states = first_nfm.accept_states + second_nfm.accept_states
    rulebook = NFARulebook.new(
      first_nfm.rulebook.rules + second_nfm.rulebook.rules + [
        FARule.new(start_state, nil, first_nfm.start_state),
        FARule.new(start_state, nil, second_nfm.start_state)
      ]
    )

    NFADesign.new(start_state, accept_states, rulebook)
  end
end


class Repeat
  def to_nfm
    pattern_nfm = pattern.to_nfm

    start_state = Object.new
    accept_states = [start_state] + pattern_nfm.accept_states
    rulebook = NFARulebook.new(
      pattern_nfm.rulebook.rules + (pattern_nfm.accept_states.map do |accept_state|
        FARule.new(accept_state, nil, pattern_nfm.start_state)
      end) + [
        FARule.new(start_state, nil, pattern_nfm.start_state)
      ]
    )
    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class NFADesign
  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end
end

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa_design.to_nfa(state).tap { |nfa|
      nfa.read_character(character)
    }.current_states
  end
end

class NFARulebook
  def alphabet
    rules.map(&:character).compact.uniq
  end
end


class NFASimulation
  def rules_for(state)
    nfa_design.rulebook.alphabet.map { |character|
      FARule.new(state, character, next_state(state, character))
    }
  end

  def discover_states_and_rules(states)
    rules = states.flat_map { |state| rules_for(state) }
    more_states = rules.map(&:follow).to_set

    if more_states.subset?(states)
      [states, rules]
    else
      discover_states_and_rules(states + more_states)
    end
  end

  def to_dfa_design
    start_state = nfa_design.to_nfa.current_states
    states, rules = discover_states_and_rules(Set[start_state])
    accept_states = states.select { |state| nfa_design.to_nfa(state).accepting? }

    pp rules

    DFADesign.new(start_state, accept_states, DFARulebook.new(rules))
  end
end

class DFADesign < Struct.new(:start_state, :accept_states, :rulebook)
  def to_dfa
    DFA.new(start_state, accept_states, rulebook)
  end

  def accepts?(string)
    to_dfa.tap { |dfa| dfa.read_string(string) }.accepting?
  end
end

class DFA
  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end