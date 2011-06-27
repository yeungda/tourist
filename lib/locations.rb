require File.dirname(__FILE__) + '/location.rb'
require 'set'

class Locations

  INFINITY = 65000

  def initialize(locations)
    @locations = locations
    @index = locations.inject({}) {|index, location| 
      index[location.name] = location
      index
    }
  end

  def destinations
    @locations.map &:name
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
    location_to_previous = dijkstra(start)
    previous = finish
    path = []
    until location_to_previous[previous].nil? do
      path.insert 0, previous 
      previous = location_to_previous[previous]
    end
    path
  end

  def dijkstra(start)
    distances = {}
    previous_location = {}
    @locations.each {|location|
      distances[location] = INFINITY
      previous_location[location] = nil
    }
    distances[start] = 0
    locations = Set.new @locations
    while !locations.empty? do
      closest = closest(locations, distances)
      break if distances[closest] == INFINITY
      locations.delete closest
      neighbours(locations, closest).each do |neighbour|
        neighbour_distance = distances[closest] + 1
        if (neighbour_distance < distances[neighbour])
          distances[neighbour] = neighbour_distance
          previous_location[neighbour] = closest
        end
      end
    end
    return previous_location
  end

  def closest(locations, distances)
    locations.sort_by {|location| distances[location]}.first
  end

  def neighbours(locations, location)
    location.destinations.map {|destination| @index[destination]} 
  end
end
