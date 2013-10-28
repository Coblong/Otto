class AgentsController < ApplicationController
  before_action :signed_in_user, :set_agent, only: [:show, :edit, :update, :destroy]

  def index
    @agents = Agent.all
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def new
    @estate_agent = EstateAgent.find(params[:estate_agent_id])
    @agent = @estate_agent.agents.build
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def create
    puts 'here we are in the agents createmethod'
    @estate_agent = EstateAgent.find(params[:estate_agent_id])
    @agent = @estate_agent.agents.create(agent_params)
    puts @agent.to_yaml
    if @agent.save
      flash[:success] = "Agent created!"
      redirect_to @estate_agent
    else
      render 'home'
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
