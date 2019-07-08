class AddParentIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :parent_id, :bigint
  end
end
