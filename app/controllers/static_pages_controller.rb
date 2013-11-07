class StaticPagesController < ApplicationController
  before_action :set_lists, only: [:home, :hunt]

  def home
    puts 'home called'
    if params[:estate_agent_id].nil?
      set_hunting_mode(false)
    else
      puts 'hunting mode is currently set to ' + hunting?.to_s
      if hunting?
        puts 'redirecting to hunt'
        redirect_to hunt_path params
      end
    end
  end

  def hunt
    puts 'hunt called'
    if params[:estate_agent_id].nil?
      set_hunting_mode(true)
      else
        puts 'hunting mode is currently set to ' + hunting?.to_s
        if !hunting?
          puts 'redirecting to home'
          redirect_to home
        end
      end
  end

  private

    def set_lists
      if signed_in?
        @estate_agents = current_user.estate_agents        
        @properties = Property.all

        if !params[:estate_agent_id].nil?
          @estate_agent = EstateAgent.find(params[:estate_agent_id])
          @branches = @estate_agent.branches
          @agents = @estate_agent.agents        
          @properties = @estate_agent.properties
        end
        if !params[:branch_id].nil?
          @branch = Branch.find(params[:branch_id])          
          @agents = @branch.agents
          @properties = @branch.properties
        end
        if !params[:agent_id].nil?
          @agent = Agent.find(params[:agent_id])
          @properties = @agent.properties
        end
      end
    end

end
