state :search do
  to :results do |browser, data|
    browser.find_element(:name => 'q').send_keys data[:query]
    browser.find_element(:name => 'btnG').click
    wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    wait.until do
      browser.find_elements(:css => '.r').size > 0
    end
  end
end
