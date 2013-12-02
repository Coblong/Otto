class AddExternalRefToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :external_ref, :string
  end
end
