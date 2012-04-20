class Plan
  def initialize(itinerary)
    @itinerary = itinerary
  end
  
  def execute(users)
    observations = @itinerary.map {|item|
      users[item[:user_name]].visit(item[:journey])
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
    journey.flat_map {|item| 
      if item.class == Hash 
        to_destinations(item[:journey])
      else
        item.name
      end
    }
  end

end
