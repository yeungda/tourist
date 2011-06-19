scenario :website_lifecycle do |users|
  users[:author].visit [:start, :successfully_created_article, :admin_articles]
  users[:reader].visit [:anonymous_start, :articles]
  users.values.each &:done
end

scenario :unsuccessful_log_in do |users|
  users[:forgetful_author].visit [:anonymous_start, :log_in_failed]
  users.values.each &:done
end
