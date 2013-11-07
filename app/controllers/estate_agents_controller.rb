class EstateAgentsController < ApplicationController
  before_action :set_estate_agent, only: [:show, :edit, :update, :destroy]

  def index
    @estate_agents = current_user.estate_agents
  end

  def show
    puts 'showing estate agent ' + params[:id]
    @estate_agent = EstateAgent.find(params[:id])
    @properties = @estate_agent.properties
  end

  def new
    @estate_agent = current_user.estate_agents.build
  end

  def edit
    @estate_agent = EstateAgent.find(params[:id])
  end

  def create
    @estate_agent = current_user.estate_agents.build(estate_agent_params)

    if @estate_agent.save
      flash[:success] = "Estate Agent created!"
      redirect_to root_path estate_agent_id: @estate_agent.id
    else
      render 'new'
    end
  end

  private

    def set_estate_agent
      @estate_agent = EstateAgent.find(params[:id])      
      @estate_agents = current_user.estate_agents
      @branches = @estate_agent.branches
      @agents = @estate_agent.agents
      @properties = @estate_agent.properties
    end

    def estate_agent_params
      params.require(:estate_agent).permit(:name, :comment)
    end

end
