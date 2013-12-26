class RenamePostCodeOnAreaCodes < ActiveRecord::Migration
  def change
    rename_column :area_codes, :post_code, :description
  end
end
