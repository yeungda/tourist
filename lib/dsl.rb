@world = {
  :scenarios => [],
  :locations => {},
  :users => []
}

def scenario(name, &block)
  # create Users
  # execute block
  @world[:scenarios] << {:name => name, :block => block}
end

def location(name, &block)
  @current_location = name
  @world[:locations][@current_location] = {:block => block, :transitions => [], :observations => []}
  block.yield
  @current_location = nil
end

def to(name, &block)
  @world[:locations][@current_location][:transitions] << {:destination => name, :block => block}
end

def observations(&block)
  @world[:locations][@current_location][:observations] << {:block => block}
end

def user(name, options, &user_data)
  #options has :role
  raise 'name is mandatory' if name.nil?
  raise ':role option is mandatory' if options[:role].nil?
  @world[:users] << {:name => name, :role => options[:role], :data => user_data.yield}
end
