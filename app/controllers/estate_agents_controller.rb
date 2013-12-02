class EstateAgentsController < ApplicationController
  before_action :set_estate_agent, only: [:new, :show, :edit, :update, :destroy]

  def index
    puts 'Calling estate agents index'
    if !current_user
      render :nothing => true, :status => :service_unavailable
    else
      @estate_agents = current_user.estate_agents    
      respond_to do |format|
        format.json { render :json => @estate_agents }
        format.html  { render :html => @estate_agents }
      end
    end
  end

  def show
    @estate_agent = EstateAgent.find(params[:id])
    @properties = @estate_agent.properties
  end

  def new
    puts 'creating a new estate agent'
    @estate_agent = current_user.estate_agents.build
  end

  def edit
    @estate_agent = EstateAgent.find(params[:id])
  end

  def update
    @estate_agent.name = params[:estate_agent][:name]
    @estate_agent.comment = params[:estate_agent][:comment]
    if @estate_agent.save
      render 'show'
    end
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
      if current_user
        @estate_agents = current_user.estate_agents        
        @properties = Property.all

        if !params[:id].nil? and params[:id].to_i > 0
          @estate_agent = EstateAgent.find(params[:id])      
          @estate_agents = current_user.estate_agents
          @branches = @estate_agent.branches
          @agents = @estate_agent.agents
          @properties = @estate_agent.properties
        end
      end
    end

    def estate_agent_params
      params.require(:estate_agent).permit(:name, :comment)
    end

end
