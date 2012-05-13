#!/usr/bin/env ruby
Dir[File.dirname(__FILE__) + "/../../../lib/main.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/states/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/users/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/journeys/*.rb"].each {|file| require file }

main = Main.new(@world)
main.describe
