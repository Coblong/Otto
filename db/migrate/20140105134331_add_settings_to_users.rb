class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_left_nav, :boolean
    add_column :users, :show_future, :boolean
  end
end
