class Observer

  def initialize(block)
    @block = block
  end

  def observe(browser)
    @block.yield(browser)
  end
end
