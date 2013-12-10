class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :description
      t.string :colour

      t.timestamps
    end
  end
end
