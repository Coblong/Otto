class AddImageUrlToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :image_url, :string
  end
end
