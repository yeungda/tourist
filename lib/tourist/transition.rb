class Transition
  def initialize(destination, block)
    @destination = destination
    @block = block
  end

  def destination
    @destination
  end

  def transition(browser, user_data)
    @block.call(browser, user_data)
  end
end
