class CreateAgentProperties < ActiveRecord::Migration
  def change
    create_table :agents_properties, :id => false do |t|
      t.integer :agent_id
      t.integer :property_id
    end
  end
end
