class RenamePostCodeOnProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :postcode, :post_code
  end
end
