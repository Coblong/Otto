class CreatePostCodes < ActiveRecord::Migration
  def change
    create_table :post_codes do |t|
      t.integer :user_id
      t.string :post_code
      t.string :comment

      t.timestamps
    end
    add_index :post_codes, [:user_id, :created_at]
  end
end
