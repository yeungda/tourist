class Plan
  def initialize(itinerary)
    @itinerary = itinerary
  end
  
  def execute(users)
    @itinerary.each {|item|
      users[item[:user_name]].visit(item[:journey])
    }
    users.values.each &:done
  end

end
