require 'yaml'
require File.dirname(__FILE__) + "/../../structural-matcher/structural_matcher.rb"

def verify
  log = File.open( "./reports/observations.yaml" )
  YAML::load_documents(log) { |observation|
    @expectations.each { |expectation|
      if expectation[:for].nil? or StructuralMatcher.match(expectation[:for], observation)[:matches?]
        result = StructuralMatcher.match(expectation[:expectations], observation['observations'])
        puts "[#{observation['id']}][OK] #{expectation[:description]}" if result[:matches?]
        puts "[#{observation['id']}]FAILED] #{expectation[:description]} because #{result[:description]}" if not result[:matches?]
      end
    }
  }
end

def expectation(the_expectation)
  @expectations = @expectations || []
  @expectations << the_expectation
end
