scenario :website_lifecycle do |users|
  users[:author].visit [:successfully_created_article, :admin_articles]
  users[:reader].visit :articles
  users.values.each &:done
end

scenario :unsuccessful_log_in do |users|
  users[:forgetful_author].visit :log_in_failed
  users.values.each &:done
end
