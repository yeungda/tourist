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

