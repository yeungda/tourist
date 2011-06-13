Dir[File.dirname(__FILE__) + "/lib/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/roles/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/users/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/scenarios/*.rb"].each {|file| require file }

@scenarios.each do |scenario|
  scenario.play @users
end

@blackbox.print
