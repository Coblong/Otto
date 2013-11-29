class CreateBranchProperties < ActiveRecord::Migration
  def change
    create_table :branches_properties, :id => false do |t|
      t.integer :branch_id
      t.integer :property_id
    end
  end
end
