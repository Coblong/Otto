class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :hunt]

  def home 
    if !current_agent.nil?
      render "agents/show"
    elsif !current_branch.nil?
      render "branches/show"
    elsif !current_estate_agent.nil?
      render "estate_agents/show"
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
      end
  end
end
