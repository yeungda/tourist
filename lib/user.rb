require "selenium-webdriver"

class User

  def initialize(name, user_data, blackbox)
    @name = name
    @user_data = user_data
    @blackbox = blackbox
  end

  def visit(path)
    @browser ||= Selenium::WebDriver.for :firefox
    steps = to_steps(path)
    print "#{@name} -> "
    first = true
    steps.each do |step|
      from = step.first
      to = step.last
      if first
        print "#{from.name}"
        first = false
      end
      from.visit(to, @browser, @user_data, @blackbox)
      print " -> #{to.name}"
    end
    print "\n"
  end

  def to_steps(path)
    steps = path.zip(path.last(path.size - 1))
    steps.pop
    steps
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end
end
