class Tool
  attr_accessor :name
  def initialize(name, tool_factory)
    @name = name
    @tool_factory = tool_factory
  end

  def create
    @tool_factory.call
  end
end
