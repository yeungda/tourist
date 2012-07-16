#!/usr/bin/env ruby
require 'rubygems'
require 'tourist'

def is_a_page
  tag :page
  observations do
    {
      :title => 'hello world'
    }
  end
end

state :start do
  to :page_a do end
end

state :page_a do
  is_a_page
  to :page_b do end
end

state :page_b do
  is_a_page
end

journey :both_pages do
  stage do
    user_name :anyone
    intention [:page_b]
  end
end

user :anyone do 
  {}
end

scope 'Pages' do
  criteria 'tags' => [:page]

  it 'should have a title' do |observations|
    assert_structure(observations, {:title => /.+/})
  end
end

main = Tourist::Main.new(@world)
main.journey 
verify(@verify_world)
