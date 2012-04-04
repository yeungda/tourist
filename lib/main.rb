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
    @blackbox = Blackbox.new
    @users = world[:users].inject({}) {|users, user| 
      users.merge({user[:name] => User.new(user[:name], user[:data], @blackbox)})
    }
  end

  def describe
    def unplanned(plans)
      planned_states = plans.reduce(Set.new) {|set, plan| 
        plan.destinations.each {|destination| set.add destination}
        set
      }
      known_states = @states.destinations
      unplanned_states = known_states - planned_states.to_a
      "**** UNPLANNED STATES (#{unplanned_states.size}) ****\n#{unplanned_states.join("\n")}"
    end

    def algebra(plans)
      unique_destinations = plans.inject(Set.new) {|total, plan| total + plan.destinations}
      dict = Identifier.hash_with_identifier unique_destinations.size
      plans_shorthand = plans.map {|plan| plan.destinations.to_a.map {|destination| 
        val = dict[destination]
        dict[destination] = val
        val
      }.join('+')}.join("\n")
      reference = dict.map {|destination,id| "#{id} = #{destination}"}.join("\n")
      "**** ALGRBRAIC VIEW ****\n#{reference}\n#{plans_shorthand}"
    end
    plans = plan()
    puts([algebra(plans), unplanned(plans)].join("\n\n"))
  end

  def execute
    plan().map {|plan| plan.execute(@users)}
    @blackbox.print
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

