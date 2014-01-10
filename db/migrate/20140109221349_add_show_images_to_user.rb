class AddShowImagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :show_images, :boolean

    User.all.each do |u|
      u.update_attributes(show_images: true)
    end
  end
end
