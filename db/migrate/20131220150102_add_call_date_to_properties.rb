class AddCallDateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :call_date, :date, :default => Date.today
  end
end
