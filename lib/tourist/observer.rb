class Tourist::Observer

  def initialize(block)
    @block = block
  end

  def observe(browser)
    @block.call(browser)
  end
end
