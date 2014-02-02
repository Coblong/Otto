class AddImagesFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :images, :integer
    remove_column :users, :show_images
    User.all.each do |u|
      u.update_attributes(images: 0)
    end
  end  
end
