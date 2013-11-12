class AddFieldsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :postcode, :string
    add_column :properties, :asking_price, :string
    add_column :properties, :status, :string
  end
end
