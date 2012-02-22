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
