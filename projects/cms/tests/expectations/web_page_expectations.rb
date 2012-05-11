expectation({
  :description => 'every web page should have a title',
  :for => {
    'tags' => [:web_page],
  },
  :expectations => {
    :page_title => /.+/
  }
})

