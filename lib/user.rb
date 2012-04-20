require "selenium-webdriver"

class User

  def initialize(name, user_data, blackbox)
    @name = name
    @user_data = user_data
    @blackbox = blackbox
  end

  def visit(path)
    @browser ||= Selenium::WebDriver.for :firefox
    print "#{@name} -> "
    visit_with_context(path)
    print "\n"
  end

  def contextual_data(context)
    context.reduce(@user_data) {|data, context|
      data[context]
    }
  end

  def done
    @browser.close unless @browser.nil?
    @browser = nil
  end

  private

  def visit_with_context(path, context=[], previous_step=nil)
    path.each {|next_step|
      if !previous_step.nil?
        if next_step.class == Hash
          visit_with_context(next_step[:journey], context + [next_step[:context]], previous_step)
          next_step = next_step[:journey].last
        else
          print " -> #{next_step.name}"
          previous_step.visit(next_step, @browser, contextual_data(context), @blackbox)
        end
      else
        print "#{next_step.name}"
      end
      previous_step = next_step
    }
  end

end
