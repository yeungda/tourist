class Plan
  def initialize(journey_name, itinerary)
    @itinerary = itinerary
    @journey_name = journey_name
  end
  
  def execute(users)
    blackbox = Blackbox.new(@journey_name)
    observations = @itinerary.map {|item|
      users[item[:user_name]].visit(item[:journey], blackbox)
    }
    users.values.each &:done
    observations
  end

  def destinations
    @itinerary.reduce(Set.new) {|set, item| 
      set + to_destinations(item[:journey])
    }
  end

  def to_destinations(journey)
    journey.map {|item| 
      if item.class == Hash 
        to_destinations(item[:journey])
      else
        item.name
      end
    }.flatten
  end

end
