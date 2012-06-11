require "selenium-webdriver"
class WebDriverTool
  def get
    @@browser ||= Selenium::WebDriver.for :firefox
  end

  def off
    @@browser.close unless @browser.nil?
  end
end

tool :browser do
  WebDriverTool.new
end
