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

  def current_properties(filter)

    puts 'Getting current properties based upon filter'

    if !current_property.nil?
      properties = current_property.branch.properties.where(closed: show_closed?)
    else
      if !current_agent.nil?
        if current_area_code.nil?
          properties = current_agent.properties.where(closed: show_closed?)
        else
          properties = current_agent.properties.where(area_code_id: current_area_code, closed: show_closed?)
        end
      else
        if !current_branch.nil?
          properties = current_branch.properties.where(closed: show_closed?)
          if current_area_code.nil?
            properties = current_branch.properties.where(closed: show_closed?)
          else
            properties = current_branch.properties.where(area_code_id: current_area_code, closed: show_closed?)
          end
        else
          if !current_estate_agent.nil?
            properties = current_estate_agent.properties.where(closed: show_closed?)
            if current_area_code.nil?
              properties = current_estate_agent.properties.where(closed: show_closed?)
            else
              properties = current_estate_agent.properties.where(area_code_id: current_area_code, closed: show_closed?)
            end
          else
            if current_area_code.nil?        
              properties = Property.where("estate_agent_id in (?)", EstateAgent.where(user_id: current_user.id).collect(&:id)).where(closed: show_closed?)
            else        
              properties = Property.where("estate_agent_id in (?) and area_code_id = ?", EstateAgent.where(user_id: current_user.id).collect(&:id), current_area_code).where(closed: show_closed?)
            end
          end
        end
      end
    end

    if filter == "viewings"
      properties.where("view_date > ?", Time.now)
    else
      properties
    end
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
  
  def show_closed(show)
    puts 'Setting show_closed to ' + show.to_s
    session[:closed] = show 
  end
  
  def show_closed?
    puts 'Show_closed is ' + session[:closed].to_s
    session[:closed]
  end
  
  def set_estate_agent(estate_agent)
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
  end
end
