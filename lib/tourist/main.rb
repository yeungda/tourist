Dir[File.dirname(__FILE__) + "/*.rb"].each {|file| require file }

class Tourist::Main
  def initialize(world)
    @states = Tourist::States.new(
      world[:states].map {|name, data| 
      Tourist::State.new(
        data[:name],
        transitions(data[:transitions]), 
        observations(data[:observations]),
        data[:tags]
      )
    })

    @journeys = world[:journeys].map {|journey| Tourist::Journey.new(journey[:name], journey[:block], @states)}

    @tools = Tourist::Tools.new(tools(world[:tools]))

    @users = world[:users].inject({}) {|users, user| 
      tool = @tools.create(user[:options][:tool])
      users.merge({user[:name] => Tourist::User.new(user[:name], user[:data], tool )})
    }
  end

  def describe
    def unplanned_view(plans)
      planned_states = plans.reduce(Set.new) {|set, plan| 
        plan.destinations.each {|destination| set.add destination}
        set
      }
      known_states = @states.destinations
      unplanned_states = known_states - planned_states.to_a
      "**** UNPLANNED (#{unplanned_states.size}) ****\n#{unplanned_states.join("\n")}"
    end

    def algebra_view(plans)
      unique_destinations = plans.inject(Set.new) {|total, plan| total + plan.destinations}
      dict = Tourist::Identifier.hash_with_identifier unique_destinations.size
      plans_shorthand = plans.map {|plan| plan.destinations.to_a.map {|destination| 
        val = dict[destination]
        dict[destination] = val
        val
      }.join('+')}.join("\n")
      reference = dict.keys.sort_by {|symbol| 
        dict[symbol]
      }.map{ |key| 
        "#{dict[key]} = #{key}"
      }.join("\n")
      "**** SHORTHAND PLANS ****\n#{reference}\n#{plans_shorthand}"
    end

    def plan_view(plans)
      all_journies = plans.map {|plan| plan.destinations.join("\n")}.join("\n\n")
      "**** PLANS ****\n#{all_journies}"
    end
    plans = plan()
    puts([plan_view(plans), algebra_view(plans), unplanned_view(plans)].join("\n\n"))
  end

  def tour
    Tourist::Blackbox.clear
    plan().map {|plan| plan.execute(@users)}
    @users.values.each &:done
  end

  private

  def plan
    @journeys.map &:plan
  end

  def transitions(transitions)
    transitions.map {|transition| Tourist::Transition.new(transition[:destination], transition[:block])}
  end

  def observations(observations)
    observations.map {|observation| Tourist::Observer.new(observation[:block])}
  end
  
  def tools(tools)
    tools.map {|tool| Tourist::Tool.new(tool[:name], tool[:tool_factory])}
  end
end

