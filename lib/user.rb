require "selenium-webdriver"

class User

  def initialize(name, targets, role, user_data, observers)
    @name = name
    @targets = targets
    @role = role
    @user_data = user_data
    @observers = observers
  end

  def visit(locations)
    @browser ||= Selenium::WebDriver.for :firefox
    locations = [locations] unless locations.respond_to? :each

    @targets.resolve(locations).each do |location|
      puts "#{@name}\tvisiting #{location.name}"
      location.visit(@browser, @user_data.yield)
      @observers.observe(location.name, @browser)
    end
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end
end
