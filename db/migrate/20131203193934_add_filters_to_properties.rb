class AddFiltersToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :estate_agent_id, :integer
    add_column :properties, :branch_id, :integer
    add_column :properties, :agent_id, :integer
  end
end
