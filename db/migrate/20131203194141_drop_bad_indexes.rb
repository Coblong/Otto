class DropBadIndexes < ActiveRecord::Migration
  def change
    remove_index :properties, name: :index_properties_on_agent_id_and_created_at
    remove_index :properties, name: :index_properties_on_branch_id_and_created_at
    remove_index :properties, name: :index_properties_on_estate_agent_id_and_created_at
  end
end
