class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :comment
      t.integer :estate_agent_id

      t.timestamps
    end
  end
end
