class AddIndexToAgents < ActiveRecord::Migration
  def change
    add_index :agents, [:estate_agent_id, :created_at]
  end
end
