require "selenium-webdriver"

class User

  def initialize(name, locations, role, user_data, blackbox)
    @name = name
    @locations = locations
    @role = role
    @user_data = user_data
    @blackbox = blackbox
  end

  def visit(destinations)
    @browser ||= Selenium::WebDriver.for :firefox
    destinations = [destinations] unless destinations.respond_to? :each
    path = @locations.resolve(destinations)
    steps = path.zip(path.last(path.size - 1))
    steps.pop

    steps.each do |step|
      from = step.first
      to = step.last
      puts "#{@name}\tvisiting #{to.name}"
      from.visit(to, @browser, @user_data, @blackbox)
    end
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end
end
