#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../../../lib/blackbox.rb"

def analysis
  def all_observations
    log = File.open(Blackbox::LOG_PATH)
    observations = []
    docs = YAML::load_documents(log) { |observation|
      observations << observation
    }
    observations
  end

  def max(a, b)
    if a.nil? or b > a then b else a end
  end

  def min(a, b)
    if a.nil? or b < a then b else a end
  end

  summary = all_observations.reduce({}) { |summary, observation|
    journey = observation['journey']
    summary.merge(
      {
        journey => {
          :min => min(if summary.has_key?(journey) then summary[journey][:min] else nil end, observation['timestamp']),
          :max => max(if summary.has_key?(journey) then summary[journey][:max] else nil end, observation['timestamp'])
        }
      }
    )
  }
  time_taken_by_journey = summary.keys.reduce({}) {|time_taken_by_journey, key|
    time_taken_by_journey.merge({
      key => summary[key][:max] - summary[key][:min]
    })
  }
  puts time_taken_by_journey.inspect
end

analysis
