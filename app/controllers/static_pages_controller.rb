class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :filters, :faq]

  def home 
    if signed_in?
      puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      puts 'the state filter is ' + state_filter?.to_s
      puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      if state_filter? == "open"
        puts 'Loading open'
        @days_properties_hash = Hash.new
        add_overview_panel
        add_overdue_properties
        add_weeks_properties
      elsif state_filter? == "viewings"
        puts 'Loading viewings'
        add_viewings
      elsif state_filter? == "closed"
        puts 'Loading closed'
        @days_properties_hash = Hash.new
        add_closed_properties
      elsif state_filter? == "all"
        puts 'Loading all'
        @days_properties_hash = Hash.new
        add_closed_properties
        add_overdue_properties
        add_weeks_properties
      end
    end
  end
  
  private

    def set_lists
      if signed_in?

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

        if !params[:state_filter].nil? and !params[:state_filter].empty?
          state_filter(params[:state_filter])
        end
      end
    end
end
