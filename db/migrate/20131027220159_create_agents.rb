class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :comment
      t.integer :branch_id

      t.timestamps
    end
    add_index :agents, [:branch_id, :created_at]
  end
end
