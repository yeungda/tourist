Dir[File.dirname(__FILE__) + "/*.rb"].each {|file| require file }

class Main
  def initialize(world)
    @locations = Locations.new(
      world[:locations].map {|name, data| 
      Location.new(
        data[:name],
        transitions(data[:transitions]), 
        observations(data[:observations])
      )
    })

    @scenarios = world[:scenarios].map {|scenario| Scenario.new(scenario[:name], scenario[:block], @locations)}
    @blackbox = Blackbox.new
    @users = world[:users].inject({}) {|users, user| 
      users.merge({user[:name] => User.new(user[:name], user[:data], @blackbox)})
    }
  end

  def plan
    plans = @scenarios.map &:plan
    planned_locations = plans.reduce(Set.new) {|set, plan| 
      plan.destinations.each {|destination| set.add destination}
      set
    }
    known_locations = @locations.destinations
    unplanned_locations = known_locations - planned_locations.to_a
    puts "unplanned locations (#{unplanned_locations.size}): #{unplanned_locations}"
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
