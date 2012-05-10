#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../../../lib/verify.rb"

expectation({
  :description => 'every page should have a title',
  :for => {
    'tags' => [:web_page],
  },
  :expectations => {
    :page_title => /.+/
  }
})

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

verify
