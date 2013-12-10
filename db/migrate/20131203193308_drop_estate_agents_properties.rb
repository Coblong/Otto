class DropEstateAgentsProperties < ActiveRecord::Migration
  def change
    drop_table :estate_agents_properties
  end
end
