require File.expand_path(File.dirname(__FILE__) + '/../lib/states.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/transition.rb')
require File.expand_path(File.dirname(__FILE__) + '/assert.rb')

do_nothing = lambda {}

def t(destination)
  Transition.new(destination, lambda {})
end

a = State.new(:a, [t(:b)], [])
b = State.new(:b, [t(:c)], [])
c = State.new(:c, [t(:d)], [])
d = State.new(:d, [t(:e)], [])
e = State.new(:e, [], [])
f = State.new(:f, [], [])

targets = States.new [a]
assert_equals(targets.resolve([:a]), [a])

a = State.new(:a, [t(:b)], [])
b = State.new(:b, [], [])
targets = States.new [a, b]
assert_equals(targets.resolve([:a, :b]), [a, b])

a = State.new(:a, [t(:b)], [])
b = State.new(:b, [t(:c)], [])
c = State.new(:c, [], [])
targets = States.new [c,b,a]
assert_equals(targets.resolve([:a, :c]), [a, b, c])


a = State.new(:a, [t(:b)], [])
b = State.new(:b, [t(:c)], [])
c = State.new(:c, [t(:d)], [])
d = State.new(:d, [t(:e)], [])
e = State.new(:e, [], [])
targets = States.new [a,b,c,d,e]
assert_equals(targets.resolve([:a, :e]), [a, b, c, d, e])


a = State.new(:a, [t(:b), t(:f)], [])
b = State.new(:b, [t(:c), t(:a)], [])
c = State.new(:c, [t(:b)], [])
f = State.new(:f, [], [])
assert_equals(States.new([a,b,c,f]).resolve([:a, :c, :f]), [a, b, c, b, a, f])
