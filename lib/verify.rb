require 'yaml'
require File.dirname(__FILE__) + "/blackbox.rb"
require File.dirname(__FILE__) + "/../../structural-matcher/structural_matcher.rb"

def verify
  log = File.open(Blackbox::LOG_PATH)
  pass_count = 0
  fail_count = 0
  YAML::load_documents(log) { |observation|
    @expectations.each { |expectation|
      if expectation[:for].nil? or StructuralMatcher.match(expectation[:for], observation)[:matches?]
        result = StructuralMatcher.match(expectation[:expectations], observation['observations'])
        if result[:matches?]
          puts "[#{observation['id']}][OK] #{expectation[:description]}"
          pass_count += 1
        else
          puts "[#{observation['id']}]FAILED] #{expectation[:description]} because #{result[:description]}"
          fail_count += 1
        end
      end
    }
  }
  puts "\n#{pass_count} passed, #{fail_count} failed\n\n"
end

def expectation(the_expectation)
  @expectations = @expectations || []
  @expectations << the_expectation
end
