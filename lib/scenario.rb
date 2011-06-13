class Scenario
  def initialize(name, block)
    @name = name
    @block = block
  end

  def play(users)
    puts "playing scenario #{@name}"
    @block.yield(users)
  end
end
