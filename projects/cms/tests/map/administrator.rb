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

state :log_in_successful do
  to :dashboard do end

  observations do |browser|
    {:page_title => browser.title}
  end
end

state :dashboard do
  to :admin_articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end
end

state :admin_articles do

  to :new_article do |browser, data|
    browser.find_element(:link_text => 'New Article').click
  end

  observations do |browser|
    {
      :articles => browser.find_element(:css => 'table#articles').text
    }
  end
end

state :new_article do

  to :successfully_created_article do |browser, data|
    browser.find_element(:id => 'article_title').send_keys data[:article_title]
    browser.find_element(:id => 'article_body').send_keys data[:article_body]
    browser.find_element(:id => 'article_submit').click
  end

  to :unsuccessfully_created_article do |browser, data|
    browser.find_element(:id => 'article_title').send_keys data[:article_title]
    browser.find_element(:id => 'article_body').send_keys data[:article_body]
    browser.find_element(:id => 'article_submit').click
  end
end

state :successfully_created_article do
  to :admin_articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end

  observations do |browser|
    {
      :article => browser.find_element(:css => '.attributes_table.article').text
    }
  end
end

state :unsuccessfully_created_article do 
  
end
