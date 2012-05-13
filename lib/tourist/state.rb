class State
  attr_reader :name
  def initialize(name, transitions, observations, tags)
    @name = name
    @transitions = transitions
    @observations = observations
    @transitions = transitions.inject({}) {|hash, transition| 
      hash[transition.destination] = transition
      hash 
    }
    @tags = tags
  end

  def destinations
    @transitions.keys
  end

  def visit(destination, browser, user_data, blackbox)
    @transitions[destination.name].transition(browser, user_data)
    destination.observe(browser, blackbox)
  end

  def observe(browser, blackbox)
    observations = @observations.reduce({}) {|observations, observation| observations.merge(observation.observe(browser)) }
    blackbox.log(@name, @tags, observations)
  end


  def to_s
    @name
  end
end
