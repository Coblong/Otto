class AddCallDateToPropertiesAgain < ActiveRecord::Migration
  def change
    add_column :properties, :call_date, :date, :default => Date.current()
  end
end
