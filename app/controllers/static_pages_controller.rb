class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :stats]

  def home 
    if !current_agent.nil?
      render "agents/show"
    elsif !current_branch.nil?
      render "branches/show"
    elsif !current_estate_agent.nil?
      render "estate_agents/show"
    end

    if signed_in?
      if current_user.show_overview
        @estate_agents = current_user.estate_agents

        @week_ahead_hash = Hash.new
        @week_ahead_hash['Monday'] = {}
        @week_ahead_hash['Tuesday'] = {}
        @week_ahead_hash['Wednesday'] = {}
        @week_ahead_hash['Thursday'] = {}
        @week_ahead_hash['Friday'] = {}
        @week_ahead_hash['Saturday'] = {}
        @week_ahead_hash['Sunday'] = {}
      end    
      
      @days_properties_hash = Hash.new

      if show_all? or show_closed?
        puts 'Loading closed properties'
        closed_properties = Property.where(closed: true)
        closed_agents = Branch.where("id in (?)", closed_properties.collect(&:branch_id))
        @days_properties_hash[get_key('Closed Properties', closed_properties.size, closed_agents.size)] = closed_properties
      end
      if !show_closed?
        overdue_properties = Property.where("call_date < ?", Date.today).where(closed: false)
        overdue_agents = Branch.where("id in (?)", overdue_properties.collect(&:branch_id))
        if overdue_properties.any?
          @days_properties_hash[get_key("Overdue", overdue_properties.size, overdue_agents.size)] = overdue_properties
        end    
        (0..7).each do |offset|
          properties = Property.where("call_date > ? and call_date < ?", Date.today + offset, Date.tomorrow + offset).where(closed: false)        
          agents = Branch.where("id in (?)", properties.collect(&:branch_id))
          day = (Date.today+offset).strftime('%A')
          is_sunday = day == 'Sunday'          

          if current_user.show_overview
            days_viewings = Property.where("view_date > ? and view_date < ?", Date.today + offset, Date.tomorrow + offset).where(closed: false)        
            @week_ahead_hash[day] = build_overview_hash(properties, days_viewings)
          end

          if offset == 0
            day = "Today"
          elsif offset == 1
            day = "Tomorrow"
          end
          @days_properties_hash[get_key(day, properties.size, agents.size)] = properties        
          if is_sunday
            if current_user.show_future
              future_properties = Property.where("call_date > ?", (Date.today + offset+1)).where(closed: false)
              future_agents = Branch.where("id in (?)", future_properties.collect(&:branch_id))
              @days_properties_hash[get_key("Future", future_properties.size, future_agents.size)] = future_properties
            end
            break
          end
        end
      end  
    end      
  end

  def viewings
    @days_properties_hash = Hash.new
    properties = Property.where("view_date > ?", Date.today).where(closed: false)
    agents = Branch.where("id in (?)", properties.collect(&:branch_id))
    @days_properties_hash[get_key('Viewings', properties.size, agents.size)] = properties
  end

  def stats
  end
  
  private

    def set_lists
      if signed_in?
        show_closed(params[:closed] == "true")
        show_all(params[:all] == "true")

        if !params[:area_code].nil? and !params[:area_code].empty?
          if params[:area_code].to_i > 0
            set_area_code(AreaCode.find(params[:area_code]))
          else
            set_area_code(nil)
          end
        end

        if !params[:estate_agent].nil? and !params[:estate_agent].empty?
          if params[:estate_agent].to_i > 0
            set_estate_agent(EstateAgent.find(params[:estate_agent]))
          else
            set_estate_agent(nil)
          end
        end

        if !params[:branch].nil? and !params[:branch].empty?
          if params[:branch].to_i > 0
            set_branch(Branch.find(params[:branch]))
          else
            set_branch(nil)
          end
        end

        if !params[:agent].nil? and !params[:agent].empty?
          if params[:agent].to_i > 0
            set_agent(Agent.find(params[:agent]))
          else
            set_agent(nil)
          end
        end
      end
    end

    def get_key(day, properties, agents)
      if properties == 0
        day + " - Nothing to do"
      else
        day + " - " + properties.to_s + (properties == 1 ? ' call - ' : " calls - ") + agents.to_s + (agents == 1 ? ' agent' : " agents")
      end
    end

    def build_overview_hash(properties, viewings)
      overview_hash = Hash.new
      overview_hash["Viewings"] = viewings.size()
      properties.each do |property|
        overview_hash[property.estate_agent.id] = 1 + (overview_hash[property.estate_agent.id] ||= 0)
      end            
      overview_hash
    end
end
