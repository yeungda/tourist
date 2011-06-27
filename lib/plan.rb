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
      item[:journey].each {|destination| set.add(destination.name)}
      set
    }
  end

end
