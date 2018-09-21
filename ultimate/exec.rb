require './ultimate/machine'

p tape = Tape.new(%w[1 0 1], '1', [], '_')
p tape.move_head_left
p tape.move_head_right
p tape.write('1')

p rule = TMRule.new(1, '0', 2, '1', :right)

p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
p rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))
p rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_')))

p rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))

rulebook = DTMRulebook.new([
  TMRule.new(1, '0', 2, '1', :right),
  TMRule.new(1, '1', 1, '0', :left),
  TMRule.new(1, '_', 2, '1', :right),
  TMRule.new(2, '0', 2, '0', :right),
  TMRule.new(2, '1', 2, '1', :right),
  TMRule.new(2, '_', 3, '_', :left),
])

p configuration = TMConfiguration.new(1, tape)
p configuration = rulebook.next_configuration(configuration)
p configuration = rulebook.next_configuration(configuration)
p configuration = rulebook.next_configuration(configuration)

dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
p dtm.current_configuration
p dtm.accepting?
p dtm.step
p dtm.accepting?
p dtm.run
p dtm.accepting?

tape = Tape.new(%w[1 2 1], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
p dtm.run
p dtm.accepting?
p dtm.stuck?
