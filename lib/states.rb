require File.dirname(__FILE__) + '/state.rb'
require 'set'

class States

  INFINITY = 65000

  def initialize(states)
    @states = states
    @index = states.inject({}) {|index, state| 
      index[state.name] = state
      index
    }
  end

  def destinations
    @states.map &:name
  end

  def resolve(destinations)
    destinations = destinations.map {|destination| @index[destination]}
    return [destinations.first] if destinations.size == 1
    next_destinations = destinations.last(destinations.size - 1)
    waypoints = destinations.zip(next_destinations)
    waypoints.pop

    [destinations.first] + waypoints.map do |waypoint|
      resolve_single(waypoint.first, waypoint.last)
    end.flatten
  end

  private

  def resolve_single(start, finish)
    state_to_previous = dijkstra(start)
    previous = finish
    path = []
    until state_to_previous[previous].nil? do
      path.insert 0, previous 
      previous = state_to_previous[previous]
    end
    path
  end

  def dijkstra(start)
    distances = {}
    previous_state = {}
    @states.each {|state|
      distances[state] = INFINITY
      previous_state[state] = nil
    }
    distances[start] = 0
    states = Set.new @states
    while !states.empty? do
      closest = closest(states, distances)
      break if distances[closest] == INFINITY
      states.delete closest
      neighbours(states, closest).each do |neighbour|
        neighbour_distance = distances[closest] + 1
        if (neighbour_distance < distances[neighbour])
          distances[neighbour] = neighbour_distance
          previous_state[neighbour] = closest
        end
      end
    end
    return previous_state
  end

  def closest(states, distances)
    states.sort_by {|state| distances[state]}.first
  end

  def neighbours(states, state)
    state.destinations.map {|destination| @index[destination]} 
  end
end
