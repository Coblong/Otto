class RenameExternalIdOnProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :external_id, :external_ref
  end
end
