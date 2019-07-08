class AddRepliesToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :replies, :bigint, default: 0
  end
end
