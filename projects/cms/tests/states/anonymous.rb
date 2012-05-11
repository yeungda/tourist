require File.dirname(__FILE__) + "/common.rb"

state :start do
  to :log_in do |browser, data|
    browser.navigate.to data[:url]
  end

  to :home do |browser, data|
    browser.navigate.to data[:url]
  end
end

state :home do
  is_a_web_page
  to :articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end
end

state :articles do
  is_a_web_page

  to :article do |browser, data|
    browser.find_element(:xpath => "//td[text() = '#{data[:article_title]}']/../td/a[text() = 'Show']").click
  end

  observations do |browser|
    {
      :articles => browser.find_elements(:css => 'table tr').select {|row| 
          row.find_elements(:css => 'td').size > 0
        }.map {|row| 
          {
            :title => row.find_elements(:css => 'td').first.text
          }
        }
    }
  end
end

state :article do
  is_a_web_page
  observations do |browser|
    {
      :title => browser.find_element(:css, 'h1').text,
      :body => browser.find_element(:xpath, '//h1/following-sibling::*').text
    }
  end
end

state :log_in do
  is_a_web_page
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
  is_a_web_page
  observations do |browser|
    {
      :page_title => browser.title,
      :message => browser.find_element(:css => '.flash_alert').text
    }
  end
end

