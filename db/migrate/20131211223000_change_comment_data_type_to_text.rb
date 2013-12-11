class ChangeCommentDataTypeToText < ActiveRecord::Migration
  def change
    change_column :estate_agents, :comment, :text
  end
end
