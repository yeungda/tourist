scope "log in failed for unsuccessful login journey" do
  criteria(
    'journey' => :unsuccessful_log_in,
    'location' => :log_in_failed
  )

  it "should show an error message" do |observations|
    assert_structure(observations, {
      :message => 'Invalid email or password.'
    })
  end
end

