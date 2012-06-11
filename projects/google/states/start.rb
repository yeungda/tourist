state :start do
  to :search do |browser, data|
    browser.navigate.to data[:url]
  end
end
