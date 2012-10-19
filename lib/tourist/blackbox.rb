require 'yaml'
require 'fileutils'

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

  def initialize(journey_name=nil, context=[], user_state={})
    @journey_name = journey_name
    @context = context
    @user_state = user_state
    @log_file = "#{LOG_PATH}/#{@journey_name}.yaml"
  end
  
  def log(location, tags, data)
    ensure_log_dir_exists
    File.open(@log_file, 'a' ) { |out|
      YAML.dump( {
          'id' => COUNTER.next,
          'journey' => @journey_name,
          'location' => location, 
          'tags' => tags,
          'timestamp' => Time.now, 
          'context' => @context,
          'user_state' => @user_state,
          'observations' => data
      }, out)
     } 
  end

  def with_context(context)
    Tourist::Blackbox.new(@journey_name, context, @user_state)
  end

  def with_user_state(user_state)
    Tourist::Blackbox.new(@journey_name, @context, user_state)
  end

  def print
    File.open(LOG_PATH, 'r' ) do |file|
      file.readlines.each {|line| puts line}
    end
  end

  private 

  def ensure_log_dir_exists
    FileUtils.mkdir_p LOG_PATH unless File.exist? LOG_PATH
  end

  LOG_PATH = './reports/observations'

end
