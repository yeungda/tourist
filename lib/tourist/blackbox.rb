require 'yaml'

class Tourist::Blackbox

  class Counter
    def initialize
      @counter = 0
    end

    def next
      @counter += 1
    end

  end

  COUNTER = Counter.new

  def self.each_observation &block
    Dir["#{LOG_PATH}/*.yaml"].each {|file|
      log = File.open(file)
      YAML::load_documents(log, &block)
    }
  end

  def clear
    File.delete @log_file if File.exists? @log_file
  end

  def initialize(journey_name=nil, context=[])
    @journey_name = journey_name
    @context = context
    @log_file = "#{LOG_PATH}/#{@journey_name}.yaml"
  end
  
  def log(location, tags, data)
    File.open(@log_file, 'a' ) { |out|
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

  private 

  LOG_PATH = './reports/observations'

end
