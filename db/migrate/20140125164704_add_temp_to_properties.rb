class AddTempToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :temp, :boolean, default: false
  end
end
