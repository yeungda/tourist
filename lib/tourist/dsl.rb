@world = {
  :journeys => [],
  :states => {},
  :users => [],
  :tools => []
}

def journey(name, &block)
  # create Users
  # execute block
  @current_journey = {:name => name, :categories => [], :stages => []}
  @world[:journeys] << @current_journey
  block.call
  @current_journey = nil
end

def category(category_name)
  @current_journey[:categories] << category_name
end

def stage &block
  @current_stage = {}
  @current_journey[:stages] << @current_stage
  block.call
  @current_stage = nil
end

def user_name name
  @current_stage[:user_name] = name
end

def intention state_list
  @current_stage[:intention] = state_list
end

def state(name, &block)
  @current_state = name
  @world[:states][@current_state] = {
    :name => name, 
    :block => block, 
    :transitions => [],
    :observations => [],
    :tags => []
  }
  block.call
  @current_state = nil
end

def to(name, &block)
  @world[:states][@current_state][:transitions] << {:destination => name, :block => block}
end

def observations(&block)
  @world[:states][@current_state][:observations] << {:block => block}
end

def tag(the_tag)
  @world[:states][@current_state][:tags] << the_tag
end

def user(name, options={}, &user_data)
  raise 'name is mandatory' if name.nil?
  @world[:users] << {:name => name, :data => user_data.call, :options => options}
end

def tool(name, &tool_factory)
  @world[:tools] << {:name => name, :tool_factory => tool_factory}
end
