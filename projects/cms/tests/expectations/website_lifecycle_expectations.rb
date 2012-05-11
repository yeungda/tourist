expectation({
  :description => 'forgetful author should see an error message',
  :for => {
    'journey' => :unsuccessful_log_in,
    'location' => :log_in_failed
  },
  :expectations => {
    :message => 'Invalid email or password.'
  }
})

expectation({
  :description => "author's first article should look like this",
  :for => {
    'journey' => :website_lifecycle,
    'location' => :successfully_created_article,
    'context' => [:first]
  },
  :expectations => {
    :article => /sunny side of the street/
  }
})

expectation({
  :description => "reader should see the author's first article in article listing",
  :for => {
    'journey' => :website_lifecycle,
    'location' => :articles,
  },
  :expectations => {
    :articles => [
      {
        :title => 'robots, ftw'
      }
    ]
  }
})

expectation({
  :description => "reader should see the author's first article",
  :for => {
    'journey' => :website_lifecycle,
    'location' => :article,
    'context' => [:first]
  },
  :expectations => {
    :title => 'robots, ftw',
    :body => 'call it what you want'
  }
})
