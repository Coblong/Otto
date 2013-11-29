class CreateEstateAgentProperties < ActiveRecord::Migration
  def change
    create_table :estate_agents_properties, :id => false do |t|
      t.integer :estate_agent_id
      t.integer :property_id
    end
  end
end
