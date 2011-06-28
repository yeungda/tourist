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
