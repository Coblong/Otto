desc "This task is called by the Heroku scheduler add-on"
task :update_properties => :environment do
  puts "Updating properties..."
  Robot.execute
  puts "done."
end

task :send_reminders => :environment do
  User.send_reminders
end