class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :hunt]

  def home     
    if defined? @agent
      render "agents/show"
    elsif defined? @branch 
      render "branches/show"
    elsif defined? @estate_agent 
      render "estate_agents/show"
    end
  end

  private

    def set_lists
      if signed_in?
        @estate_agents = current_user.estate_agents        
        @properties = Property.all

        if !params[:estate_agent_id].nil? and !params[:estate_agent_id].empty?
          @estate_agent = EstateAgent.find(params[:estate_agent_id])
          @branches = @estate_agent.branches
          @agents = @estate_agent.agents        
          @properties = @estate_agent.properties
        end
        if !params[:branch_id].nil? and !params[:branch_id].empty?
          @branch = Branch.find(params[:branch_id])          
          @agents = @branch.agents
          @properties = @branch.properties
        end
        if !params[:agent_id].nil? and !params[:agent_id].empty?
          @agent = Agent.find(params[:agent_id])
          @branch = @agent.branch
          @agents = @branch.agents
          @properties = @agent.properties
        end        
      end
    end

end
