class IncreasePropertiesUrlLengthAgain < ActiveRecord::Migration
  def change
    change_column :properties, :url, :string, :limit => 500 
  end
end
