Dir[File.dirname(__FILE__) + "/*.rb"].each {|file| require file }

class Main
  def initialize(world)
    @states = States.new(
      world[:states].map {|name, data| 
      State.new(
        data[:name],
        transitions(data[:transitions]), 
        observations(data[:observations])
      )
    })

    @scenarios = world[:scenarios].map {|scenario| Scenario.new(scenario[:name], scenario[:block], @states)}
    @blackbox = Blackbox.new
    @users = world[:users].inject({}) {|users, user| 
      users.merge({user[:name] => User.new(user[:name], user[:data], @blackbox)})
    }
  end

  def plan
    plans = @scenarios.map &:plan
    planned_states = plans.reduce(Set.new) {|set, plan| 
      plan.destinations.each {|destination| set.add destination}
      set
    }
    known_states = @states.destinations
    unplanned_states = known_states - planned_states.to_a
    puts "unplanned states (#{unplanned_states.size}): #{unplanned_states}"
    plans
  end

  def graph_plan
    plans = plan()
  end

  def execute
    plan().map {|plan| plan.execute(@users)}
  end

  def print
    execute()
    @blackbox.print
  end

  def validate
  end

  private

  def transitions(transitions)
    transitions.map {|transition| Transition.new(transition[:destination], transition[:block])}
  end

  def observations(observations)
    observations.map {|observation| Observer.new(observation[:block])}
  end
end

