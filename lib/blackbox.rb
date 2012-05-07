require 'yaml'

class Blackbox
  LOG_PATH = './reports/observations.yaml'
  def initialize(journey_name=nil, context=[])
    @journey_name = journey_name
    @context = context
  end
  
  def log(location, data)
    File.open(LOG_PATH, 'a' ) { |out|
      YAML.dump( {
          'journey' => @journey_name,
          'location' => location, 
          'timestamp' => Time.now, 
          'context' => @context,
          'observations' => data
      }, out )
     } 
  end

  def with_context(context)
    Blackbox.new(@journey_name, context)
  end

  def print
    File.open(LOG_PATH, 'r' ) do |file|
      file.readlines.each {|line| puts line}
    end
  end
end
