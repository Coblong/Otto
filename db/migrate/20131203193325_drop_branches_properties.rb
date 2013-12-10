class DropBranchesProperties < ActiveRecord::Migration
  def change
    drop_table :branches_properties
  end
end
