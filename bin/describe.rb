#!/usr/bin/env ruby
require 'tourist'
Dir["./states/*.rb"].each {|file| require file }
Dir["./users/*.rb"].each {|file| require file }
Dir["./journeys/*.rb"].each {|file| require file }

main = Tourist::Main.new(@world)
main.describe
