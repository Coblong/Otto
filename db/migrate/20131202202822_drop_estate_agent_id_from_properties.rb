class DropEstateAgentIdFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :estate_agent_id
    remove_column :properties, :branch_id
    remove_column :properties, :agent_id
  end
end
