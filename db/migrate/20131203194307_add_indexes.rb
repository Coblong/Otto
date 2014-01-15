class AddIndexes < ActiveRecord::Migration
  def change
    add_index :statuses, [:user_id, :description], :unique => true
  end
end
