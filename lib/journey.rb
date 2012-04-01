class Journey
  def initialize(name, block, locations)
    @name = name
    @block = block
    @locations = locations
  end

  def plan
    plan = @block.yield
    itinerary = plan.map {|item| 
      {:user_name => item[:user_name], :journey => @locations.resolve(item[:intention])}
    }
    Plan.new(itinerary)
  end
end
