require 'yaml'
class Blackbox
  def initialize
    @log = []
  end
  def log(location, data)
    @log << {'location' => location, 'observations' => data}
  end

  def print
    puts "\n*******Blackbox Data*******"
    puts @log.to_yaml
  end
end
