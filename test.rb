Dir[File.dirname(__FILE__) + "/lib/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/roles/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/users/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/scenarios/*.rb"].each {|file| require file }

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
    @scenarios.map &:plan
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

main = Main.new(@world)
actions = (main.methods - Object.methods).map &:to_s
if ARGV.length == 0 || !actions.include?(ARGV[0])
  puts "please provide an action of either #{actions}"
  exit 0
end
main.send(ARGV[0])
