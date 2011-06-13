require 'yaml'
class Blackbox
  def initialize
    @log = {} 
  end
  def log(location, data)
    @log.merge!({location => data})
  end

  def print
    puts "*******Blackbox Data*******"
    puts @log.to_yaml
  end
end
