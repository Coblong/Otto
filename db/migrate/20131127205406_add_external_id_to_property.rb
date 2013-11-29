class AddExternalIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :external_id, :string
  end
end
