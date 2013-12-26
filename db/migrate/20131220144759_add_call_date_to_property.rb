class AddCallDateToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :call_date, :datetime
  end
end
