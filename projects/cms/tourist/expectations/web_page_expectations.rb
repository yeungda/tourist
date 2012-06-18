scope 'All web pages' do
  criteria 'tags' => [:web_page]

  it 'should have a title' do |observations|
    assert_structure(observations, {
      :page_title => /.+/
    })
  end
end
