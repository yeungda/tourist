require "selenium-webdriver"

class User

  def initialize(name, user_data, blackbox)
    @name = name
    @user_data = user_data
    @blackbox = blackbox
  end

  def visit(path)
    @browser ||= Selenium::WebDriver.for :firefox
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
