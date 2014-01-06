class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :stats]

  @@PAGE_LIVE = 1
  @@PAGE_VIEWINGS = 2
  @@PAGE_CLOSED = 3
  @@PAGE_ALL = 4

  def home 
    if signed_in?
      @page = @@PAGE_LIVE
      @page = params[:page].to_i unless params[:page].nil?
      puts 'Loading data for diary - ' + @page.to_s

      if @page == @@PAGE_LIVE
        puts 'Loading data for live view'
        @show_overview = current_user.show_overview
        @days_properties_hash = Hash.new
        add_overview_panel
        add_overdue_properties
        add_weeks_properties
      elsif @page == @@PAGE_VIEWINGS
        puts 'Loading data for viewings view'
        add_viewings
      elsif @page == @@PAGE_CLOSED
        puts 'Loading data for closed view'
        @days_properties_hash = Hash.new
        add_closed_properties
       elsif @page == @@PAGE_ALL
        puts 'Loading data for all view'
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
end
