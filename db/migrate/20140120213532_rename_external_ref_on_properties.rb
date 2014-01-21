class RenameExternalRefOnProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :external_ref, :external_ref_deprecated
  end
end
