class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name
      t.string :comment
      t.integer :estate_agent_id

      t.timestamps
    end
  end
end
