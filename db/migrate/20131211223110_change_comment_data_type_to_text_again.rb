class ChangeCommentDataTypeToTextAgain < ActiveRecord::Migration
  def change
    change_column :estate_agents, :comment, :text, :limit => 500
    change_column :branches, :comment, :text, :limit => 500
    change_column :agents, :comment, :text, :limit => 500
  end
end
