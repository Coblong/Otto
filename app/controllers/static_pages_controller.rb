class StaticPagesController < ApplicationController

  def home
    puts 'home'
    if signed_in?
      @estate_agents = current_user.estate_agents
      if !params[:estate_agent_id].nil?
        @estate_agent = EstateAgent.find(params[:estate_agent_id])
        @branches = @estate_agent.branches
        if @branches.size.to_i == 1
          @branch = @branches.first
          @agents = @estate_agent.agents
        else
          @agents = @estate_agent.agents
        end
      end
      if !params[:branch_id].nil?
        @branch = Branch.find(params[:branch_id])
        @agents = @branch.agents
      end
      if !params[:agent_id].nil?
        @agent = Agent.find(params[:agent_id])
      end
    end
  end

  def help
    puts 'help'
  end

	def about
  end
end
