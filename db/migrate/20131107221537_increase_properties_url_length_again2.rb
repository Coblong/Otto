class IncreasePropertiesUrlLengthAgain2 < ActiveRecord::Migration
  def change
    change_column :properties, :url, :string, :limit => nil 
  end
end
