class AddExternalRefToEstateAgents < ActiveRecord::Migration
  def change
    add_column :estate_agents, :external_ref, :string
  end
end
