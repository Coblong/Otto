class AddSstcToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :sstc, :boolean
  end
end
