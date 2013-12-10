class AddIndexes < ActiveRecord::Migration
  def change
    add_index :properties, [:estate_agent_id, :created_at]
    add_index :properties, [:branch_id, :created_at]
    add_index :properties, [:agent_id, :created_at]
    add_index :statuses, [:user_id, :description], :unique => true
  end
end
