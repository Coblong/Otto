class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address
      t.string :url
      t.integer :estate_agent_id
      t.integer :branch_id
      t.integer :agent_id

      t.timestamps
    end
    add_index :properties, [:estate_agent_id, :created_at]
    add_index :properties, [:branch_id, :created_at]
    add_index :properties, [:agent_id, :created_at]
  end
end
