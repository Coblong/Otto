class IncreasePropertiesUrlLength < ActiveRecord::Migration
  def change
    change_column :properties, :url, :string 
  end
end
