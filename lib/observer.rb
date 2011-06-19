class Observer

  def initialize(block)
    @block = block
  end

  def observe(location, browser, blackbox)
    blackbox.log(location, @block.yield(browser))
  end
end
