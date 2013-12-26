class RenamePostCodeIdOnProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :post_code_id, :area_code_id
  end
end
