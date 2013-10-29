class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.string :comment
      t.integer :estate_agent_id

      t.timestamps
    end
    add_index :branches, [:estate_agent_id, :created_at]
  end
end
