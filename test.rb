Dir[File.dirname(__FILE__) + "/lib/main.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/map/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/users/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/scenarios/*.rb"].each {|file| require file }

main = Main.new(@world)

actions = (main.methods - Object.methods).map &:to_s
if ARGV.length == 0 || !actions.include?(ARGV[0])
  puts "please provide an action of either #{actions}"
  exit 0
end
main.send(ARGV[0])
