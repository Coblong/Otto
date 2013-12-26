class AddPostCodeIdToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :post_code_id, :integer
  end
end
