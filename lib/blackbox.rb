class Blackbox
  def initialize
    @log = []
  end
  def log(location, data)
    @log << "#{location} : #{data}"
  end

  def print
    puts "*******Blackbox Data*******"
    puts @log
  end
end
