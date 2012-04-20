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

  to :logged_out do |browser, data|
    browser.find_element(:link_text => 'Logout').click
  end
end

state :admin_articles do

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

state :new_article do

  to :successfully_created_article do |browser, data, article|
    browser.find_element(:id => 'article_title').send_keys data[:article_new][:title]
    browser.find_element(:id => 'article_body').send_keys data[:article_new][:body]
    browser.find_element(:id => 'article_submit').click
  end

  to :unsuccessfully_created_article do |browser, data, article|
    browser.find_element(:id => 'article_title').send_keys data[:article_new][:title]
    browser.find_element(:id => 'article_body').send_keys data[:article_new][:body]
    browser.find_element(:id => 'article_submit').click
  end
end

state :view_article do 
  to :admin_articles do |browser, data|
    click_and_wait(browser, :link_text => 'Articles')
  end

  to :edit_article do |browser, data|
    browser.find_element(:link_text => 'Edit Article').click
  end

end

state :edit_article do
  to :admin_articles do |browser, data|
    click_and_wait(browser, :link_text => 'Articles')
  end

  to :edit_article_successful do |browser, data|
    browser.find_element(:id => 'article_title').send_keys data[:article_edit][:title]
    browser.find_element(:id => 'article_body').send_keys data[:article_edit][:body]
    browser.find_element(:id => 'article_submit').click
  end
end

state :edit_article_successful do
  to :view_article do end
end

state :delete_article do 
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

state :delete_article_success do
  to :admin_articles do end
end

state :delete_article_cancel do
  to :admin_articles do end
end

state :admin_articles_by_created_at_asc do 
  to :admin_articles do end
end

state :admin_articles_by_created_at_dsc do 
  to :admin_articles do end
end

state :admin_articles_by_updated_at_asc do 
  to :admin_articles do end
end

state :admin_articles_by_updated_at_dsc do 
  to :admin_articles do end
end

state :admin_articles_by_body_asc do 
  to :admin_articles do end
end

state :admin_articles_by_body_dsc do 
  to :admin_articles do end
end

state :admin_articles_by_title_asc do 
  to :admin_articles do end
end

state :admin_articles_by_title_dsc do 
  to :admin_articles do end
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

state :articles_filtered do end
state :articles_filter_cleared do end

state :unsuccessfully_created_article do end

state :logged_out do end
