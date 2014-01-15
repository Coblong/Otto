class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.string :msg
      t.integer :property_id
      t.string :type
      t.boolean :read, default: false
      
      t.timestamps
    end
  end
end
