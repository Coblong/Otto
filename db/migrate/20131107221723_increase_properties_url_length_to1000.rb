class IncreasePropertiesUrlLengthTo1000 < ActiveRecord::Migration
  def change
    change_column :properties, :url, :string, :limit => 1000 
  end
end
