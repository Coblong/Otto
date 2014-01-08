class SetOverviewWeeksOnUsers < ActiveRecord::Migration
  def change
    User.all.each do |u|
      u.update_attributes(overview_weeks: 1)
    end
  end
end
