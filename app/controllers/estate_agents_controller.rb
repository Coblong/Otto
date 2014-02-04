class EstateAgentsController < ApplicationController
  before_action :set_estate_agent_in_controller, only: [:new, :show, :edit, :update, :destroy]

  def index
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
    puts 'Showing estate agent'
    state_filter("open")
  end

  def new
    @estate_agent = current_user.estate_agents.build
  end

  def edit
  end

  def update
    puts 'Updating estate agent'
    estate_agent = current_estate_agent
    estate_agent.name = params[:estate_agent][:name]
    estate_agent.comment = params[:estate_agent][:comment]
    if estate_agent.save!
      puts 'Estate agent saved'
      render 'show'
    else
      puts 'Estate agent not saved...'
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

    def set_estate_agent_in_controller
      puts 'Setting the estate agent'
      set_estate_agent(EstateAgent.find(params[:id]))
      puts 'done'
    end

    def estate_agent_params
      params.require(:estate_agent).permit(:name, :comment)
    end

end
