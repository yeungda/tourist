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

    @journeys = world[:journeys].map {|journey| Journey.new(journey[:name], journey[:block], @states)}
    @users = world[:users].inject({}) {|users, user| 
      users.merge({user[:name] => User.new(user[:name], user[:data] )})
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
      dict = Identifier.hash_with_identifier unique_destinations.size
      plans_shorthand = plans.map {|plan| plan.destinations.to_a.map {|destination| 
        val = dict[destination]
        dict[destination] = val
        val
      }.join('+')}.join("\n")
      reference = dict.map {|destination,id| "#{id} = #{destination}"}.join("\n")
      "**** SHORTHAND PLANS ****\n#{reference}\n#{plans_shorthand}"
    end

    def plan_view(plans)
      all_journies = plans.map {|plan| plan.destinations.to_a.join("\n")}.join("\n\n")
      "**** PLANS ****\n#{all_journies}"
    end
    plans = plan()
    puts([plan_view(plans), algebra_view(plans), unplanned_view(plans)].join("\n\n"))
  end

  def execute
    plan().map {|plan| plan.execute(@users)}
  end

  private

  def plan
    @journeys.map &:plan
  end

  def transitions(transitions)
    transitions.map {|transition| Transition.new(transition[:destination], transition[:block])}
  end

  def observations(observations)
    observations.map {|observation| Observer.new(observation[:block])}
  end
end

