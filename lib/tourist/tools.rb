class Tools
  def initialize(tools)
    @tools = tools.reduce({}) {|name_to_tool, tool|
      name_to_tool[tool.name] = tool
      name_to_tool
    }
  end

  class NoTool
    def get
    end
    def off
    end
  end

  def create(name)
    if @tools.has_key? name
      @tools[name].create
    else
      return NoTool.new
    end
  end
end
