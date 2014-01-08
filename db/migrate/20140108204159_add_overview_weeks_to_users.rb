class AddOverviewWeeksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :overview_weeks, :integer
  end
end
