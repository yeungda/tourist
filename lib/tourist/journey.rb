class Tourist::Journey
  attr_reader :name
  attr_reader :categories

  def initialize(name, stages, categories, states)
    @name = name
    @stages = stages
    @categories = categories
    @states = states
  end

  def plan
    itinerary = @stages.map {|item| 
      {:user_name => item[:user_name], :journey => @states.resolve([:start]) + to_journey(item[:intention])}
    }
    Tourist::Plan.new(@name, itinerary)
  end

  def to_journey(intention, last_destination=:start)
     journey = []
      intention.each {|item|
        if item.class == Hash
          previous_to_end_of_part = to_journey(item[:intention], last_destination)
          journey = journey + [{
            :context => item[:context], 
            :journey => previous_to_end_of_part
          }]
          last_destination = previous_to_end_of_part.last.name
        else
          previous_to_end_of_part = @states.resolve([last_destination, item])
          journey = journey + previous_to_end_of_part.last(previous_to_end_of_part.size - 1)
          last_destination = item
        end
      }
      journey
  end
end
