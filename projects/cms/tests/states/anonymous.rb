state :start do
  to :log_in do |browser, data|
    browser.navigate.to data[:url]
  end

  to :home do |browser, data|
    browser.navigate.to data[:url]
  end
end

state :home do
  to :articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end
end

state :articles do
end

state :log_in do
  to :log_in_failed do |browser, data|
    browser.find_element(:id => 'admin_user_email').send_keys data[:email_address]
    browser.find_element(:id => 'admin_user_password').send_keys data[:password]
    browser.find_element(:id => 'admin_user_submit').click
  end

  to :log_in_successful do |browser, data|
    browser.find_element(:id => 'admin_user_email').send_keys data[:email_address]
    browser.find_element(:id => 'admin_user_password').send_keys data[:password]
    browser.find_element(:id => 'admin_user_submit').click
  end

  observations do |browser|
    {:page_title => browser.title}
  end
end

state :log_in_failed do
  observations do |browser|
    {
      :page_title => browser.title,
      :message => browser.find_element(:css => '.flash_alert').text
    }
  end
end

