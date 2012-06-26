require 'yaml'
require File.dirname(__FILE__) + "/blackbox.rb"
require File.dirname(__FILE__) + "/structural_matcher.rb"

def verify(verify_world)
  pass_count = 0
  fail_count = 0
  expectations = to_expectations([verify_world])
  Tourist::Blackbox.each_observation { |observation|
    expectations.each { |expectation|
      if expectation.applicable?(observation)
        result_success, result_description = expectation.assert(observation['observations'])
        identifier = "#{observation['journey']} ##{observation['id']}"
        if result_success
          puts "[OK] #{expectation.description} [#{identifier}]"
          pass_count += 1
        else
          puts "[FAILED] #{expectation.description} [#{identifier}] because #{result_description}"
          fail_count += 1
        end
      end
    }
  }
  puts "\n#{pass_count} passed, #{fail_count} failed\n\n"
end

def to_expectations parent_scopes
  def to_description describables
    describables.inject('') {|description, describable|
      description + 
        if description.length == 0 then '' else ' ' end + 
        describable[:description]
    }
  end

  def to_criteria scopes
    scopes.inject({}) {|criteria, scope|
      criteria.merge scope[:criteria]
    }
  end

  def to_expectation description, criteria, expectation
    Tourist::Expectation.new(description, criteria, nil, expectation[:block])
  end

  parent_scopes.last[:scopes].map {|scope|
    current_scope = parent_scopes + [scope]
    criteria = to_criteria(current_scope)
    scope[:expectations].map {|expectation|
      description = to_description(current_scope + [expectation])
      to_expectation(description, criteria, expectation)
    } + to_expectations(current_scope)
  }.flatten
end

@verify_world = {
  :scopes => [],
  :expectations => [],
  :criteria => {},
  :description => ''
}

@current_scope = [@verify_world]

def scope description, &block
  next_scope = {
    :description => description,
    :criteria => {},
    :expectations => [],
    :scopes => []
  }

  @current_scope.last[:scopes] << next_scope
  @current_scope.push next_scope
  block.call
  @current_scope.pop
end

def criteria pattern
  @current_scope.last[:criteria] = pattern
end

def it(description, &block)
  @current_scope.last[:expectations] << {:description => description, :block => block}
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
