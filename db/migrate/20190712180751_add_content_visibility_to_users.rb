class AddContentVisibilityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :content_visibility, :boolean, default: true
  end
end
