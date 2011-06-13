require '/Users/dyeung/Scratch/testjourney/lib/targets.rb'

def assert_equals(expected, actual)
  raise "#{expected} != #{actual}" unless expected == actual
end

do_nothing = lambda {}

a = Target.new(:a, [], do_nothing)
b = Target.new(:b, [:a], do_nothing)
c = Target.new(:c, [:b], do_nothing)
d = Target.new(:d, [], do_nothing)
e = Target.new(:e, [:c, :d], do_nothing)
f = Target.new(:f, [:a], do_nothing)

targets = Targets.new
targets.add(a)
assert_equals(targets.resolve(:a), [a])

targets = Targets.new
targets.add(a)
targets.add(b)
assert_equals(targets.resolve(:b), [a, b])

targets = Targets.new
targets.add(c)
targets.add(b)
targets.add(a)
assert_equals(targets.resolve(:c), [a, b, c])

targets = Targets.new
targets.add(a)
targets.add(b)
targets.add(c)
targets.add(d)
targets.add(e)
assert_equals(targets.resolve(:e), [a, b, c, d, e])
assert_equals(targets.resolve(:d), [d])

targets = Targets.new
targets.add(a)
targets.add(b)
targets.add(f)
assert_equals(targets.resolve([:b, :f]), [a, b, f])
