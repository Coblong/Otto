class AddViewDateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :view_date, :datetime
  end
end
