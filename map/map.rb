location :start do
  to :log_in do |browser, data|
    browser.navigate.to data[:url]
  end

  to :home do |browser, data|
    browser.navigate.to data[:url]
  end
end

location :home do
  to :articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end
end

location :articles do

end

location :log_in do
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

location :log_in_failed do
  observations do |browser|
    {
      :page_title => browser.title,
      :message => browser.find_element(:css => '.flash_alert').text
    }
  end
end

location :log_in_successful do
  to :dashboard do end

  observations do |browser|
    {:page_title => browser.title}
  end
end

location :dashboard do
  to :admin_articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end

  to :logged_out do |browser, data|
    browser.find_element(:link_text => 'Logout').click
  end
end

location :admin_articles do

  to :new_article do |browser, data|
    browser.find_element(:link_text => 'New Article').click
  end

  to :view_article do |browser, data|
    browser.find_element(:link_text => 'View').click
  end

  to :edit_article do |browser, data|
    browser.find_element(:link_text => 'Edit').click
  end

  to :delete_article do |browser, data|
    browser.find_element(:link_text => 'Delete').click
  end

  to :admin_articles_by_created_at_asc do |browser, data|
    click_and_wait(browser, :link_text => 'Created At')
  end

  to :admin_articles_by_created_at_dsc do |browser, data|
    click_and_wait(browser, :link_text => 'Created At')
  end

  to :admin_articles_by_updated_at_asc do |browser, data|
    click_and_wait(browser, :link_text => 'Updated At')
  end

  to :admin_articles_by_updated_at_dsc do |browser, data|
    click_and_wait(browser, :link_text => 'Updated At')
  end

  to :admin_articles_by_body_asc do |browser, data|
    click_and_wait(browser, :link_text => 'Body')
  end

  to :admin_articles_by_body_dsc do |browser, data|
    click_and_wait(browser, :link_text => 'Body')
  end

  to :admin_articles_by_title_asc do |browser, data|
    click_and_wait(browser, :link_text => 'Title')
  end

  to :admin_articles_by_title_dsc do |browser, data|
    click_and_wait(browser, :link_text => 'Title')
  end

  to :dashboard do |browser, data|
    browser.find_element(:link_text => 'Dashboard').click
  end

  observations do |browser|
    {
      :articles => browser.find_element(:css => 'table#articles').text,
      #:source => browser.page_source
    }
  end
end

def click_and_wait(browser, query)
  browser.find_element(query).click
  wait_for_articles(browser)
end

def wait_for_articles(browser)
  Selenium::WebDriver::Wait.new.until { browser.find_elements(:id => 'articles').size > 0 }
end

location :new_article do

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

location :view_article do 
  to :admin_articles do |browser, data|
    click_and_wait(browser, :link_text => 'Articles')
  end

  to :edit_article do |browser, data|
    browser.find_element(:link_text => 'Edit Article').click
  end

end

location :edit_article do
  to :admin_articles do |browser, data|
    click_and_wait(browser, :link_text => 'Articles')
  end

  to :edit_article_successful do |browser, data|
    browser.find_element(:id => 'article_title').send_keys data[:article_edit_title]
    browser.find_element(:id => 'article_body').send_keys data[:article_edit_body]
    browser.find_element(:id => 'article_submit').click
  end
end

location :edit_article_successful do
  to :view_article do end
end

location :delete_article do 
  to :delete_article_success do |browser, data| 
    browser.switch_to.alert.accept
    wait_for_articles(browser)
  end

  to :delete_article_cancel do |browser, data|
    browser.switch_to.alert.dismiss
  end

  observations do |browser|
    {
      :text => browser.switch_to.alert.text
    }
  end
end

location :delete_article_success do
  to :admin_articles do end
end

location :delete_article_cancel do
  to :admin_articles do end
end

location :admin_articles_by_created_at_asc do 
  to :admin_articles do end
end

location :admin_articles_by_created_at_dsc do 
  to :admin_articles do end
end

location :admin_articles_by_updated_at_asc do 
  to :admin_articles do end
end

location :admin_articles_by_updated_at_dsc do 
  to :admin_articles do end
end

location :admin_articles_by_body_asc do 
  to :admin_articles do end
end

location :admin_articles_by_body_dsc do 
  to :admin_articles do end
end

location :admin_articles_by_title_asc do 
  to :admin_articles do end
end

location :admin_articles_by_title_dsc do 
  to :admin_articles do end
end

location :successfully_created_article do
  to :admin_articles do |browser, data|
    browser.find_element(:link_text => 'Articles').click
  end

  observations do |browser|
    {
      :article => browser.find_element(:css => '.attributes_table.article').text
    }
  end
end

location :articles_filtered do end
location :articles_filter_cleared do end

location :unsuccessfully_created_article do end

location :logged_out do end
