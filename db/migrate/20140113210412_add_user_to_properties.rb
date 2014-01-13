class AddUserToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :user_id, :integer
    add_index  :properties, [:user_id, :created_at]

    Property.all.each do |p|
      p.update_attributes(user_id: 1)
    end
  end
end
