class AddShowOverviewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_overview, :boolean
  end
end
