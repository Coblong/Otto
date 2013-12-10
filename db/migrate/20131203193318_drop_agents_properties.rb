class DropAgentsProperties < ActiveRecord::Migration
  def change
    drop_table :agents_properties
  end
end
