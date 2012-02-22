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
    print_journey_plan(itinerary)
    Plan.new(itinerary)
  end

  def print_journey_plan(itinerary)
    puts "* Plan: #{@name} "
    itinerary.each do |individual|
      journey = individual[:journey].map {|location| location.to_s}.join("\n*** ")
      puts "** User: #{individual[:user_name]}\n*** #{journey}"
    end
  end
end
