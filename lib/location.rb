class Location
  attr_reader :name
  def initialize(name, transitions, observations)
    @name = name
    @transitions = transitions
    @observations = observations
  end

  def destinations
    @transitions.map {|transition| transition.destination }
  end

  def to_s
    @name
  end
end
