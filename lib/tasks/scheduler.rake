desc "This is the ottor robot for checking for updates on rightmove"
task :run_robot => :environment do
  
  puts "Starting robot..."  
  
  properties = Property.all
  puts 'Found ' + properties.size.to_s + ' properties'
  
  properties.each do |property|
    property.check_for_updates
  end

  puts "Done."
end
