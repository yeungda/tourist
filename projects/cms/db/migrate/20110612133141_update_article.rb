class UpdateArticle < ActiveRecord::Migration
  def self.up
    change_table(:articles) do |t|
      t.string :body
      t.string :title
    end
  end

  def self.down
  end
end
