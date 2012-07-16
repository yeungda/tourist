class Tourist::Transition
  def initialize(destination, block)
    @destination = destination
    @block = block
  end

  def destination
    @destination
  end

  def transition(browser, user_data, user_state)
    @block.call(browser, user_data, user_state)
  end
end
