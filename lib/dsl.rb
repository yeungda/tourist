require File.dirname(__FILE__) + '/targets.rb'
require File.dirname(__FILE__) + '/scenario.rb'
require File.dirname(__FILE__) + '/observers.rb'

@scenarios = []
@targets = Targets.new
@blackbox = Blackbox.new
@observers = Observers.new(@blackbox)

def scenario(name, &block)
  # create Users
  # execute block
  @scenarios << Scenario.new(name, block)
end

def location(name, &block)
  @current_location = name
  block.yield
  @current_location = nil
end

def to(name, &block)
  @targets.add(Target.new(name, [@current_location], block))
end

def observe(&block)
  @observers.add(Observer.new(@current_location, block))
end

def user(name, options, &user_data)
  #options has :role
  raise 'name is mandatory' if name.nil?
  raise ':role option is mandatory' if options[:role].nil?
  @users ||= {}
  @users[name] = User.new(name, @targets, options[:role], user_data, @observers)
end
