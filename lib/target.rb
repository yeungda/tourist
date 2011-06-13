class Target

  def initialize(name, dependencies, block)
    @name = name
    @dependencies = dependencies
    @block = block
  end

  def name
    @name
  end

  def dependencies
    @dependencies
  end

  def to_s
    @name
  end

  def visit(browser, user_data)
    @block.yield(browser, user_data)
  end
end
