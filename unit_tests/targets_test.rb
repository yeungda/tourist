require File.expand_path(File.dirname(__FILE__) + '/../lib/locations.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/transition.rb')

def assert_equals(actual, expected)
  raise "expected #{expected.to_s}, got #{actual.to_s}" unless expected == actual
end

do_nothing = lambda {}

def t(destination)
  Transition.new(destination, lambda {})
end

a = Location.new(:a, [t(:b)], [])
b = Location.new(:b, [t(:c)], [])
c = Location.new(:c, [t(:d)], [])
d = Location.new(:d, [t(:e)], [])
e = Location.new(:e, [], [])
f = Location.new(:f, [], [])

targets = Locations.new [a]
assert_equals(targets.resolve([:a]), [a])

a = Location.new(:a, [t(:b)], [])
b = Location.new(:b, [], [])
targets = Locations.new [a, b]
assert_equals(targets.resolve([:a, :b]), [a, b])

a = Location.new(:a, [t(:b)], [])
b = Location.new(:b, [t(:c)], [])
c = Location.new(:c, [], [])
targets = Locations.new [c,b,a]
assert_equals(targets.resolve([:a, :c]), [a, b, c])


a = Location.new(:a, [t(:b)], [])
b = Location.new(:b, [t(:c)], [])
c = Location.new(:c, [t(:d)], [])
d = Location.new(:d, [t(:e)], [])
e = Location.new(:e, [], [])
targets = Locations.new [a,b,c,d,e]
assert_equals(targets.resolve([:a, :e]), [a, b, c, d, e])


a = Location.new(:a, [t(:b), t(:f)], [])
b = Location.new(:b, [t(:c), t(:a)], [])
c = Location.new(:c, [t(:b)], [])
f = Location.new(:f, [], [])
assert_equals(Locations.new([a,b,c,f]).resolve([:a, :c, :f]), [a, b, c, b, a, f])
