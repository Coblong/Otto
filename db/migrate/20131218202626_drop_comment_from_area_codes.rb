class DropCommentFromAreaCodes < ActiveRecord::Migration
  def change
    remove_column :area_codes, :comment
  end
end
