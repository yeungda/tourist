class Scenario
  def initialize(name, block, locations)
    @name = name
    @block = block
    @locations = locations
  end

  def play(users)
    puts "playing scenario #{@name}"
    plan = @block.yield
    itinerary = plan.map {|item| 
      {:user_name => item[:user_name], :journey => @locations.resolve(item[:intention])}
    }
    puts "itinerary is: #{itinerary.inspect}"
    itinerary.each {|item|
      users[item[:user_name]].visit(item[:journey])
    }
    users.values.each &:done
  end
end
