class CreateEstateAgents < ActiveRecord::Migration
  def change
    create_table :estate_agents do |t|
      t.string :name
      t.string :comment
      t.integer :user_id

      t.timestamps
    end
    add_index :estate_agents, [:user_id, :created_at]
  end
end
