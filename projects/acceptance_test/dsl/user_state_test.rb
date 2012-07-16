require 'rubygems'
require 'tourist'
require 'deep_merge'

tool :fake_client do
  class FakeClient
    @signed_in = false

    def sign_in
      @signed_in = true
    end

    def recommendations
      if @signed_in
        ['a','b']
      else
        []
      end
    end

    def popular
      if @signed_in
        []
      else
        ['mickey', 'mouse']
      end
    end
  end

  class FakeClientTool
    def initialize
      @client = FakeClient.new 
    end

    def get
      @client
    end
    def off
      @client = FakeClient.new
    end
  end
  FakeClientTool.new
end

user :someone, :tool => :fake_client do
  {
    :username => 'someone',
    :password => 'password'
  }
end

journey :visit_site do
  stage do 
    user_name :someone
    intention [:home, :sign_in_successful, :home]
  end
end

state :start do
  to :home do |_, _, user_state|
    user_state.deep_merge! :signed_in => false
  end
end

state :home do
  to :sign_in do end
  observations do |client|
    {
      :recommendations => client.recommendations,
      :popular => client.popular
    } 
  end
end

state :sign_in do
  to :sign_in_successful do |client, _, user_state|
    client.sign_in
    user_state.deep_merge! :signed_in => true
  end
end

state :sign_in_successful do
  to :home do
  end
end

scope 'Home' do
  criteria 'location' => :home

  scope 'for signed in users' do
    criteria 'user_state' => {:signed_in => true}

    it 'should show recommended content' do |observations|
      assert_structure(observations, {
        :recommendations => ['a','b'],
        :popular => []
      })
    end
  end

  scope 'for anonymous users' do
    criteria 'user_state' => {:signed_in => false}

    it 'should show most popular content' do |observations|
      assert_structure(observations, {
        :recommendations => [],
        :popular => ['mickey', 'mouse']
      })
    end
  end
end

main = Tourist::Main.new(@world)
main.journey 
puts "verifying"
verify(@verify_world)
