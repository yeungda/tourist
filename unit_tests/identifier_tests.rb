require File.expand_path(File.dirname(__FILE__) + '/assert.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/identifier.rb')
assert_equals Identifier.to_s_in_base(0,2), 'A'
assert_equals Identifier.to_s_in_base(1,2), 'B'
assert_equals Identifier.to_s_in_base(2,2), 'C'
assert_equals Identifier.to_s_in_base(0,30), 'AA'
assert_equals Identifier.to_s_in_base(25,25), 'Z'
assert_equals Identifier.to_s_in_base(26,27), 'BA'
assert_equals Identifier.to_s_in_base(0,(26**3)-1), 'A' * 3
