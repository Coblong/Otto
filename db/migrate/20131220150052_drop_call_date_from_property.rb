class DropCallDateFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :call_date
  end
end
