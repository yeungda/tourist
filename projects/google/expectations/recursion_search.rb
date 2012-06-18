scope "Results" do
  criteria 'location' => :results

  it "should show 10 results" do |observations|
    throw 'not 10 results' unless observations[:results].size == 10
  end
end
