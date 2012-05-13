journey :website_lifecycle do
  [ 
    {
      :user_name => :author,
      :intention => [
        :log_in_successful,
        {
          :context => :first,
          :intention => [
            :successfully_created_article,
            :admin_articles, 
            :view_article,
            :edit_article_successful,
          ]
        },
        :admin_articles, 
        {
          :context => :second,
          :intention => [
            :successfully_created_article,
            :admin_articles, 
            :view_article,
            :edit_article_successful
          ]
        },
        :delete_article_cancel,
        :delete_article_success,
        :admin_articles_by_created_at_asc,
        :admin_articles_by_created_at_dsc,
        :admin_articles_by_updated_at_asc,
        :admin_articles_by_updated_at_dsc,
        :admin_articles_by_body_asc,
        :admin_articles_by_body_dsc,
        :admin_articles_by_title_asc,
        :admin_articles_by_title_dsc,
        :logged_out
      ]
    },
    {
      :user_name => :reader,
      :intention => [
        :start,
        :articles,
        {
          :context => :first,
          :intention => [:article]
        }
      ]
    }
  ]
end
