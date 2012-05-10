@world = {
  :journeys => [],
  :states => {},
  :users => []
}

def journey(name, &block)
  # create Users
  # execute block
  @world[:journeys] << {:name => name, :block => block}
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

def user(name, &user_data)
  #options has :role
  raise 'name is mandatory' if name.nil?
  @world[:users] << {:name => name, :data => user_data.call}
end

