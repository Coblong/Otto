class AddPropertiesPerPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :properties_per_page, :integer
    User.all.each do |user|
      user.update_attributes(properties_per_page: 5)
    end
  end
end
