class CreateEstateAgents < ActiveRecord::Migration
  def change
    create_table :estate_agents do |t|
      t.string :name
      t.string :comment

      t.timestamps
    end
  end
end
