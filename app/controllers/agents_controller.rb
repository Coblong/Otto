class AgentsController < ApplicationController
  before_action :signed_in_user, :set_agent, only: [:show, :edit, :update, :destroy]

  def index
    @agents = Agent.all
  end

  def new
    @branch = Branch.find(params[:branch_id])
    @agent = @branch.agents.build
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def create
    @branch = Branch.find(params[:branch_id])
    @agent = @branch.agents.build(agent_params)
    @agent.estate_agent = @branch.estate_agent
    if @agent.save
      flash[:success] = "Agent created!"
      redirect_to root_path estate_agent_id: @branch.estate_agent.id, branch_id: @branch.id, agent_id: @agent.id
    else
      redirect_to "new"
    end
  end

  private

    def set_agent
      @agent = Agent.find(params[:id])
      
      @estate_agents = current_user.estate_agents
      @estate_agent = @agent.branch.estate_agent 
      @branches = @estate_agent.branches
      @branch = @agent.branch
      @agents = @branch.agents
      @properties = @agent.properties
    end

    def agent_params
      params.require(:agent).permit(:name, :comment, :estate_agent)
    end

end