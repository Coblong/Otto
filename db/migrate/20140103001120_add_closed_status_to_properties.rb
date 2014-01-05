class AddClosedStatusToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :closed, :boolean
  end
end
