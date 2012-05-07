user :author do
  {
    :url => 'http://localhost:3000/admin',
    :email_address => 'admin@example.com',
    :password => 'password',
    :first => {
      :article_new => {
        :title => 'Hello World',
        :body => 'sunny side of the street'
      },
      :article_edit => {
        :title => 'robots, ftw',
        :body => 'call it what you want'
      } 
    },
    :second => {
      :article_new => {
        :title => 'times change',
        :body => 'the way you make me feel'
      },
      :article_edit => {
        :title => 'Change the second article',
        :body => 'something borrowed, something blue'
      }
    }
  }
end
