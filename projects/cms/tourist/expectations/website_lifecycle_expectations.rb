scope "author's first article" do
(
    'journey' => :website_lifecycle,
    'location' => :successfully_created_article,
    'context' => [:first]
  )

  it "should be sunny" do |observations|
    assert_structure(observations, {
      :article => /sunny side of the street/
    })
  end
end

scope "Reader looking at Articles in website lifecycle journey" do
  criteria( 
    'journey' => :website_lifecycle,
    'location' => :articles
  )

  it "should show the author's first article in article listing" do |observations|
    assert_structure(observations, {
      :articles => [
        {
          :title => 'robots, ftw'
        }
      ]
    })
  end
end

scope "Reader looking at first article in website lifecycle journey" do
  criteria( 
    'journey' => :website_lifecycle,
    'location' => :article,
    'context' => [:first]
  )

  it "should see the author's first article" do |observations|
    assert_structure(observations, {
      :title => 'robots, ftw',
      :body => 'call it what you want'
    })
  end
end
