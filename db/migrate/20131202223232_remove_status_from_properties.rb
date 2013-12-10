class RemoveStatusFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :status
  end
end
