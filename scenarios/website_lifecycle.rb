scenario :website_lifecycle do
  [ 
    {
      :user_name => :author,
      :intention => [:start, :successfully_created_article, :admin_articles]
    },
    {
      :user_name => :reader,
      :intention => [:start, :articles]
    }
  ]
end

scenario :unsuccessful_log_in do
  [
    {
      :user_name => :forgetful_author,
      :intention => [:start, :log_in_failed]
    }
  ]
end
