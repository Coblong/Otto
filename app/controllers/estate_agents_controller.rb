class EstateAgentsController < ApplicationController
  before_action :set_estate_agent, only: [:show, :edit, :update, :destroy]

  def index
    @estate_agents = EstateAgent.all
  end

  def show
    @estate_agent = EstateAgent.find(params[:id])
    puts @estate_agent.name.to_s
  end

  def new
    @estate_agent = EstateAgent.new
  end

  def edit
    @estate_agent = EstateAgent.find(params[:id])
  end

  def create
    @estate_agent = EstateAgent.new(estate_agent_params)

    if estate_agent.save
      flash[:success] = "Estate Agent created!"
      redirect_to estate_agent
    else
      render 'new'
    end
  end

  private

    def set_estate_agent
      estate_agent = EstateAgent.find(params[:id])
    end

    def estate_agent_params
      params.require(:estate_agent).permit(:name, :comment)
    end

end
