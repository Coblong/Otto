desc "This is the ottor robot for checking for updates on rightmove"
task :run_robot => :environment do
  puts "Starting robot..."  
  Property.all.each do |property|
    property.check_for_updates
  end
  puts "done."
end
