class RenamePostCodes < ActiveRecord::Migration
  def change
    rename_table :post_codes, :area_codes 
  end
end
