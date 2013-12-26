class AddSeedData < ActiveRecord::Migration
  def change
    user = User.create(name: "Cobbers", email: "paul.cobley@gmail.com", password: "password", password_confirmation: "password")
    Status.create(description: "New", colour: "FFFFFF", user_id: user.id)
    Status.create(description: "Hot", colour: "FFA399", user_id: user.id)
    Status.create(description: "Warm", colour: "FFEEA8", user_id: user.id)
    Status.create(description: "Cold", colour: "C7EAFF", user_id: user.id)    
  end
end
