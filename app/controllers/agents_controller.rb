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
    puts 'creating a new agent'
    @branch = Branch.find(params[:branch_id])
    @agent = @branch.agents.build(agent_params)
    @agent.estate_agent = @branch.estate_agent
    if @agent.save
      flash[:success] = "Agent created!"
      redirect_to @branch
    else
      redirect_to @branch
    end
  end

  private

    def set_agent
      @agent = Agent.find(params[:id])
    end

    def agent_params
      params.require(:agent).permit(:name, :comment, :estate_agent)
    end

end
