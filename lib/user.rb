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
    print "#{@name}: "
    first = true
    steps.each do |step|
      from = step.first
      to = step.last
      print (first ? "#{from.name}" : "") + " -> #{to.name}"
      first = false
      from.visit(to, @browser, @user_data, @blackbox)
    end
    print "\n"
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end
end
