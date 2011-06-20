Dir[File.dirname(__FILE__) + "/lib/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/roles/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/users/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/scenarios/*.rb"].each {|file| require file }

def transitions(transitions)
  transitions.map {|transition| Transition.new(transition[:destination], transition[:block])}
end

def observations(observations)
  observations.map {|observation| Observer.new(observation[:block])}
end

@scenarios = @world[:scenarios].map {|scenario| Scenario.new(scenario[:name], scenario[:block])}
@locations = Locations.new(
  @world[:locations].map {|name, data| 
    Location.new(
      data[:name],
      transitions(data[:transitions]), 
      observations(data[:observations])
    )
  }
)

@blackbox = Blackbox.new
@users = @world[:users].inject({}) {|users, user| 
  users.merge({user[:name] => User.new(user[:name], @locations, user[:role], user[:data], @blackbox)})
}

@scenarios.each do |scenario|
  scenario.play @users
end

@blackbox.print
