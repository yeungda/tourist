require 'yaml'

class Tourist::Blackbox
  LOG_PATH = './reports/observations.yaml'

  class Counter
    def initialize
      @counter = 0
    end

    def next
      @counter += 1
    end

  end

  COUNTER = Counter.new

  def self.clear
    File.delete(LOG_PATH) if File.exists? LOG_PATH
  end

  def initialize(journey_name=nil, context=[])
    @journey_name = journey_name
    @context = context
  end
  
  def log(location, tags, data)
    File.open(LOG_PATH, 'a' ) { |out|
      YAML.dump( {
          'id' => COUNTER.next,
          'journey' => @journey_name,
          'location' => location, 
          'tags' => tags,
          'timestamp' => Time.now, 
          'context' => @context,
          'observations' => data
      }, out)
     } 
  end

  def with_context(context)
    Tourist::Blackbox.new(@journey_name, context)
  end

  def print
    File.open(LOG_PATH, 'r' ) do |file|
      file.readlines.each {|line| puts line}
    end
  end
end
