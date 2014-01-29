module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def current_agents
    current_branch.agents unless current_branch.nil?
  end

  def get_futures_header(offset)
    header = "In Future - "
    properties = future_properties(offset)
    agents = future_agents(offset)
    header += properties.size.to_s + " call"
    header += 's' unless properties.size < 2
    header += " - " + agents.size.to_s + " agent"
    header += 's' unless agents.size < 2
    header
  end

  def get_diary_header(offset)
    if offset == 0
      day = "Today - "
    elsif offset == 1
      day = "Tomorrow - "
    else 
      day = (Date.today+offset).strftime('%A') + ' - '
    end
    properties = days_properties(offset)
    agents = days_agents(offset)
    if properties.size > 0
      header = day + properties.size.to_s + " call"
      header += 's' unless properties.size < 2
      header += " - " + agents.size.to_s + " agent"
      header += 's' unless agents.size < 2
      header
    else
      day + 'No calls'
    end    
  end

  def current_properties

    if !current_property.nil?
      if current_area_code.nil?
        puts 'Getting properties by current property'
        properties = current_property.branch.properties
      else 
        puts 'Getting properties by current property and area code'
        properties = current_property.branch.properties.where(area_code_id: current_area_code)
      end
    else
      if !current_agent.nil?
        if current_area_code.nil?
          puts 'Getting properties by agent'
          properties = current_agent.properties
        else
          puts 'Getting properties by agent and area code'
          properties = current_agent.properties.where(area_code_id: current_area_code)
        end
      else
        if !current_branch.nil?
          properties = current_branch.properties
          if current_area_code.nil?
            puts 'Getting properties by branch'
            properties = current_branch.properties
          else
            puts 'Getting properties by branch and area code'
            properties = current_branch.properties.where(area_code_id: current_area_code)
          end
        else
          if !current_estate_agent.nil?
            properties = current_estate_agent.properties
            if current_area_code.nil?
              puts 'Getting properties by estate agent'
              properties = current_estate_agent.properties
            else
              puts 'Getting properties by estate agent and area code'
              properties = current_estate_agent.properties.where(area_code_id: current_area_code)
            end
          else
            if current_area_code.nil?        
              puts 'Getting properties by user'
              properties = current_user.properties.where("estate_agent_id in (?)", current_user.estate_agents.where(user_id: current_user.id).collect(&:id))
            else        
              puts 'Getting properties by user and area code'
              properties = current_user.properties.where("estate_agent_id in (?) and area_code_id = ?", current_user.estate_agents.where(user_id: current_user.id).collect(&:id), current_area_code)
            end
          end
        end
      end
    end

    if state_open?
      puts 'Filter for open'
      properties = properties.where(closed: false)
    elsif state_viewings?
      puts 'Filter for viewings'
      properties = properties.where("view_date > ?", Time.now)
    elsif state_closed?
      puts 'Filter for closed'
      properties = properties.where(closed: true)
    end
      
    properties
  end

  def current_branches
    current_estate_agent.branches unless current_estate_agent.nil?
  end

  def set_area_code(area_code)
    if area_code.nil?
      session[:area_code] = nil
    else
      session[:area_code] = area_code
    end
  end
  
  def set_estate_agent(estate_agent)
    puts 'setting the estate agent and the state filter is ' + state_filter?
    if estate_agent.nil?
      session[:estate_agent] = nil
    else
      session[:estate_agent] = estate_agent.id
    end
    session[:branch] = nil
    session[:agent] = nil
    session[:property] = nil
  end

  def set_branch(branch)
    if branch.nil?
      session[:branch] = nil
    else
      session[:branch] = branch.id
      session[:estate_agent] = branch.estate_agent_id unless branch.nil?   
    end
    session[:agent] = nil
    session[:property] = nil
  end

  def set_agent(agent)
    if agent.nil?
      session[:agent] = nil
    else
      session[:agent] = agent.id
      session[:branch] = agent.branch_id
      session[:estate_agent] = agent.branch.estate_agent_id    
    end
    session[:property] = nil
  end

  def set_property(property)
    if property.nil?
      session[:property] = nil
    else
      session[:property] = property.id
      session[:branch] = property.branch_id
      session[:estate_agent] = property.branch.estate_agent_id    
    end
  end

  def state_filter(filter) 
    puts 'Setting the state filter to ' + filter.to_s
    session[:state_filter] = filter
  end

  def state_filter?
    if session[:state_filter].nil?
      session[:state_filter] = :open
    end
    session[:state_filter]
  end

  def state_open?
    state_filter? == "open"
  end

  def state_viewings?
    state_filter? == "viewings"
  end

  def state_closed?
    state_filter? == "closed"
  end

  def state_all?
    state_filter? == "all"
  end

  def current_area_code
    AreaCode.find(session[:area_code]) unless session[:area_code].nil?
  end

  def current_estate_agent
    EstateAgent.find(session[:estate_agent]) unless session[:estate_agent].nil?
  end

  def current_branch
    Branch.find(session[:branch]) unless session[:branch].nil?
  end

  def current_agent
    Agent.find(session[:agent]) unless session[:agent].nil?
  end

  def current_property
    Property.find(session[:property]) unless session[:property].nil?
  rescue
    puts 'Unable to find the property so it must have been removed'
    session[:property] = nil
    current_property
  end

  def get_header_class(day)
    if day.start_with? "Overdue"
      "overdue" 
    elsif day.start_with? "Future"
      "future"
    else
      ""
    end
  end

  def show_today_only(show)
    puts 'setting show today only to ' + show.to_s
    session[:show_today_only] = show
  end

  def show_today_only?
    if session[:show_today_only].nil?
      session[:show_today_only] = false
    end
    session[:show_today_only].to_s == 'true'
  end

  def pluralize(text, number)
    return text.pluralize if number != 1
    text
  end
end
