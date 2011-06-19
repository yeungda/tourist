require "selenium-webdriver"

class User

  def initialize(name, locations, role, user_data)
    @name = name
    @locations = locations
    @role = role
    @user_data = user_data
  end

  def visit(destinations)
    @browser ||= Selenium::WebDriver.for :firefox
    destinations = [destinations] unless destinations.respond_to? :each

    @locations.resolve(destinations).each do |location|
      puts "#{@name}\tvisiting #{location.name}"
      location.visit(@browser, @user_data.yield)
    end
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end
end
