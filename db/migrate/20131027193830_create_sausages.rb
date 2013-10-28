class CreateSausages < ActiveRecord::Migration
  def change
    create_table :sausages do |t|

      t.timestamps
    end
  end
end
