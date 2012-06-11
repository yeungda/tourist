expectation({
  :description => 'the search for recursion should show 10 results',
  :for => {
    'location' => :results
  },
  :assertions => lambda do |observation|
    throw 'not 10 results' unless observation[:results].size == 10
  end
})
