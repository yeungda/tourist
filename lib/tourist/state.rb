class Tourist::State
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

  def visit(destination, browser, user_data, user_state, blackbox)
    @transitions[destination.name].transition(browser, user_data, user_state)
    destination.observe(browser, blackbox.with_user_state(user_state))
  end

  def observe(browser, blackbox)
    observations = @observations.reduce({}) {|observations, observation| observations.merge(observation.observe(browser)) }
    blackbox.log(@name, @tags, observations)
  end


  def to_s
    @name
  end
end
