class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :property_id
      t.integer :agent_id
      t.integer :branch_id
      t.integer :estate_agent_id
      t.string :content
      t.string :type

      t.timestamps
    end
  end
end
