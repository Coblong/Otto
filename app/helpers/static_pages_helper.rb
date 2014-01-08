module StaticPagesHelper

  def add_overview_panel
    if current_user.show_overview

      @branches = Hash.new
      @overview_headers = Hash.new
      @overviews_for_day = Hash.new

      day = Date.today.at_beginning_of_week
      (1..current_user.overview_weeks).each do |week_number|
        puts 'Adding week ' + week_number.to_s
        headers = Array.new
        @overview_headers[week_number] = headers
        
        (1..7).each do |offset|  
          / Add the header to a has for the week (Monday, TuesDay etc)/
          header = day.strftime("%A %d/%m")
          headers << header
          puts "...adding " + header

          / Create an array for all of the overviews for this day /
          overviews = Array.new
          @overviews_for_day[header] = overviews

          / Add the viewings for this day /          
          viewings = Property.where("view_date >= ? and view_date < ?", day.beginning_of_day, ( day+1 ).beginning_of_day).where(closed: false)
          if !viewings.empty?
            puts "......adding viewings"
            viewings_hash = Hash.new
            viewings_hash["Viewings"] = viewings.size
            overviews << viewings_hash
          end

          / Add the viewings for this day /
          properties = Property.where("call_date >= ? and call_date < ?", day.beginning_of_day, ( day+1 ).beginning_of_day).where(closed: false)
          branches = Branch.where("id in (?)", properties.collect(&:branch_id))
          branches.each do  |branch|
            puts "......adding " + branch.estate_agent.name
            branch_properties = properties.where(branch_id: branch.id)
            branch_hash = Hash.new
            branch_hash[branch.id] = branch_properties.size
            overviews << branch_hash
            @branches[branch.id] = branch
          end

          day += 1
        end
      end
    end
  end

  def add_overdue_properties
    overdue_properties = Property.where("call_date < ?", Date.today.beginning_of_day).where(closed: false)    
    overdue_properties = apply_filters(overdue_properties)
    overdue_agents = Branch.where("id in (?)", overdue_properties.collect(&:branch_id))
    if overdue_properties.any?
      @days_properties_hash[get_key("Overdue", overdue_properties.size, overdue_agents.size)] = overdue_properties
    end    
  end
        
  def add_weeks_properties    
    (0..7).each do |offset|
      properties = Property.where("call_date >= ? and call_date < ?", (Date.today + offset).beginning_of_day, (Date.tomorrow + offset).beginning_of_day).where(closed: false)        
      properties = apply_filters(properties)
      agents = Branch.where("id in (?)", properties.collect(&:branch_id))
      day = (Date.today+offset).strftime('%A')
      is_sunday = day == 'Sunday'          
      if @show_overview
        days_viewings = Property.where("view_date >= ? and view_date < ?", (Date.today + offset).beginning_of_day, (Date.tomorrow + offset).beginning_of_day).where(closed: false)        
        @week_ahead_hash[day] = build_overview_hash(properties, days_viewings)
      end

      if offset == 0
        day = "Today"
      elsif offset == 1
        day = "Tomorrow"
      end
      
      @days_properties_hash[get_key(day, properties.size, agents.size)] = properties unless properties.empty?        
      if is_sunday
        if current_user.show_future
          future_properties = Property.where("call_date >= ?", (Date.today + offset+1).beginning_of_day).where(closed: false)
          future_agents = Branch.where("id in (?)", future_properties.collect(&:branch_id))
          @days_properties_hash[get_key("Future", future_properties.size, future_agents.size)] = future_properties unless future_properties.empty?
        end
        break
      end
    end
  end
  
  def add_viewings
    @days_properties_hash = Hash.new
    properties = Property.where("view_date >= ?", Date.today.beginning_of_day).where(closed: false)
    properties = apply_filters(properties)
    agents = Branch.where("id in (?)", properties.collect(&:branch_id))
    @days_properties_hash[get_key('Viewings', properties.size, agents.size)] = properties
  end
  
  def add_closed_properties
    closed_properties = Property.where(closed: true)
    closed_properties = apply_filters(closed_properties)
    closed_agents = Branch.where("id in (?)", closed_properties.collect(&:branch_id))
    @days_properties_hash[get_key('Closed Properties', closed_properties.size, closed_agents.size)] = closed_properties
  end

  def build_overview_hash(properties, viewings)
    overview_hash = Hash.new
    overview_hash["Viewings"] = viewings.size() unless viewings.empty?
    properties.each do |property|
      overview_hash[property.estate_agent.id] = 1 + (overview_hash[property.estate_agent.id] ||= 0)
    end            
    overview_hash
  end

  def get_key(day, properties, agents)
    if properties == 0
      day
    else
      day + " - " + properties.to_s + (properties == 1 ? ' call - ' : " calls - ") + agents.to_s + (agents == 1 ? ' agent' : " agents")
    end
  end

  def apply_filters (properties)
    if !current_area_code.nil?
      / always apply the area filter if its set /
      properties = properties.where(area_code_id: current_area_code.id)
    end
    if !current_agent.nil?
      / filter by agent first as its the finest grain /
      properties = properties.where(agent_id: current_agent.id)
    else
      if !current_branch.nil?
        / if no agent try and filter by branch next /
        properties = properties.where(branch_id: current_branch.id)
      else
        if !current_estate_agent.nil?
          / finally try the estate agent filter /
          properties = properties.where(estate_agent_id: current_estate_agent.id)
        end
      end
    end
    properties
  end
end
