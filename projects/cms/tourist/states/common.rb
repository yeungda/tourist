def is_a_web_page
  tag :web_page
  observations do |browser|
    {:page_title => browser.title}
  end
end
