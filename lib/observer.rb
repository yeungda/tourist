class Observer
  attr_reader :location

  def initialize(location, block)
    @location = location
    @block = block
  end

  def observe(browser, blackbox)
    blackbox.log(location, @block.yield(browser))
  end
  
end
