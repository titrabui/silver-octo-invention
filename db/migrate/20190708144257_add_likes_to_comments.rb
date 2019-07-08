class AddLikesToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :likes, :bigint, default: 0
  end
end
