class Location
  attr_reader :name
  def initialize(name, transitions, observations)
    @name = name
    @transitions = transitions
    @observations = observations
    @transitions = transitions.inject({}) {|hash, transition| 
      hash[transition.destination] = transition
      hash 
    }
  end

  def destinations
    @transitions.keys
  end

  def visit(destination, browser, user_data)
    @transitions[destination.name].transition(browser, user_data)
  end

  def to_s
    @name
  end
end
