class AddListedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :listed, :boolean, default: true
  end
end
