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

  def visit(destination, browser, user_data, blackbox)
    @transitions[destination.name].transition(browser, user_data)
    destination.observe(browser, blackbox)
  end

  def observe(browser, blackbox)
    @observations.each {|observation| observation.observe(name, browser, blackbox) }
  end

  def to_s
    @name
  end
end
