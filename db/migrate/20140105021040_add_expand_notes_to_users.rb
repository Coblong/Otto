class AddExpandNotesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :expand_notes, :boolean
  end
end
