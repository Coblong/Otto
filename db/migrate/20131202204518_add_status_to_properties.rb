class AddStatusToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :status_id, :integer
  end
end
