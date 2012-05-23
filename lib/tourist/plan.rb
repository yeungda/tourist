class Tourist::Plan
  attr_reader :journey_name

  def initialize(journey_name, itinerary)
    @itinerary = itinerary
    @journey_name = journey_name
  end
  
  def execute(users)
    blackbox = Tourist::Blackbox.new(@journey_name)
    observations = @itinerary.map {|item|
      users[item[:user_name]].visit(@journey_name, item[:journey], blackbox)
    }
    observations
  end

  def destinations
    @itinerary.reduce([]) {|set, item| 
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
