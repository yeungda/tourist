state :results do
  observations do |browser|
    result_headings = browser.find_elements(:css => 'h3.r').map &:text
    {
      :results => result_headings
    }
  end
end
