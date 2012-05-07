#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../../../../structural-matcher/structural_matcher.rb"
require 'yaml'

def verify
  log = File.open( "./reports/observations.yaml" )
  YAML::load_documents(log) { |observation|
    @expectations.each { |expectation|
      if expectation[:for].nil? or StructuralMatcher.match(expectation[:for], observation)[:matches?]
        result = StructuralMatcher.match(expectation[:expectations], observation['observations'])
        puts "[#{observation['id']}][OK] #{expectation[:description]}" if result[:matches?]
        puts "[FAILED] #{expectation[:description]} because #{result[:description]}" if not result[:matches?]
      end
    }
  }
end

def expectation the_expectation
  @expectations = @expectations || []
  @expectations << the_expectation
end

expectation({
  :description => 'every page should have a title',
  :expectations => {
    :page_title => /.+/
  }
})

expectation({
  :description => 'forgetful author should see an error message',
  :for => {
    'journey' => :unsuccessful_log_in,
    'location' => :log_in_failed
  },
  :expectations => {
    :message => 'Invalid email or password.'
  }
})

expectation({
  :description => "author's first article should look like this",
  :for => {
    'journey' => :website_lifecycle,
    'location' => :successfully_created_article,
    'context' => [:first]
  },
  :expectations => {
    :article => /sunny side of the street/
  }
})

verify
