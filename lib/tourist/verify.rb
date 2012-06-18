require 'yaml'
require File.dirname(__FILE__) + "/blackbox.rb"
require File.dirname(__FILE__) + "/structural_matcher.rb"

def verify(verify_world)
  log = File.open(Tourist::Blackbox::LOG_PATH)
  pass_count = 0
  fail_count = 0
  expectations = to_expectations(verify_world)
  YAML::load_documents(log) { |observation|
    expectations.each { |expectation|
      if expectation.applicable?(observation)
        result_success, result_description = expectation.assert(observation['observations'])
        if result_success
          puts "[#{observation['id']}][OK] #{expectation.description}"
          pass_count += 1
        else
          puts "[#{observation['id']}][FAILED] #{expectation.description} because #{result_description}"
          fail_count += 1
        end
      end
    }
  }
  puts "\n#{pass_count} passed, #{fail_count} failed\n\n"
end

def to_expectations verify_world
  verify_world[:scopes].values.map {|scope|
    scope[:expectations].map {|expectation|
      Tourist::Expectation.new(
        scope[:description] + " " + expectation[:description],
        scope[:criteria],
        nil,
        expectation[:block]
      )
    }
  }.flatten
end

@verify_world = {
  :scopes => {}
}

def scope description, &block
  if not @verify_world[:scopes].has_key?(description)
    @verify_world[:scopes][description] = {
      :description => description,
      :criteria => nil,
      :expectations => []
    }
  end
  @current_scope = @verify_world[:scopes][description]
  block.call
  @current_scope = nil
end

def criteria pattern
  @current_scope[:criteria] = pattern
end

def it(description, &block)
  @current_scope[:expectations] << {:description => description, :block => block}
end

def assert_structure(actual, expected)
    result = Tourist::StructuralMatcher.match(expected, actual)
    if not result[:matches?]
      throw result[:description]
    end
end

class Tourist::Expectation
  attr_reader :description
  attr_reader :scope
  attr_reader :structural_expectations

  def initialize(description, scope, structural_expectations, assertions)
    @description = description
    @scope = scope
    @structural_expectations = structural_expectations
    @assertions = assertions
    throw 'at least one of expectations or assertions must be provided' if @structural_expectations.nil? and @assertions.nil?
  end

  def applicable?(observation)
    scope.nil? or Tourist::StructuralMatcher.match(scope, observation)[:matches?]
  end

  def assert(observations)
    if not @structural_expectations.nil?
      result = Tourist::StructuralMatcher.match(@structural_expectations, observations)
      [result[:matches?], result[:description]]
    elsif not @assertions.nil?
      begin
        @assertions.call(observations)
        [true]
      rescue
        [false, $!.message]
      end
    else
      throw 'unknown expectation description'
    end
  end
end
