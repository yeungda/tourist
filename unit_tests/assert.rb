def assert_equals(actual, expected)
  raise "expected #{expected.to_s}, got #{actual.to_s}" unless expected == actual
end
