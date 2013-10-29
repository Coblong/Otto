class AddEstateAgentToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :estate_agent_id, :integer
    add_index :agents, [:estate_agent_id, :created_at]
  end
end
