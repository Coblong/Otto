class StatusesController < ApplicationController
  before_action :set_status, only: [:show]

  def index
    if !current_user
      render :nothing => true, :statuses => :service_unavailable
    else
      @statuses = current_user.statuses
      respond_to do |format|
        format.json { render :json => @statuses }
        format.html  { render :html => @statuses }
      end
    end
  end

  def new
    @status = current_user.statuses.build
  end

  def edit
    @status = Status.find(params[:id])
  end

  def show    
  end

  def update
    @status = Status.find(params[:id])
    if @status.update_attributes!(status_params)
      redirect_to user_statuses_path(current_user)
    else
      render 'show'
    end
  end

  def create
    @status = current_user.statuses.build(status_params)

    if @status.save
      flash[:success] = "Status created!"
      redirect_to user_statuses_path(current_user)
    else
      render 'new'
    end
  end

  def destroy
    begin
      @status = Status.find(params[:id])
      @status.destroy()      
      redirect_to user_statuses_path(current_user)
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "#{e}"
      redirect_to user_statuses_path(current_user)
    end
  end

  private

    def set_status
      if current_user
        @estate_agents = current_user.estate_agents                

        if !params[:id].nil? and params[:id].to_i > 0
          @status = Status.find(params[:id])
          @estate_agent = EstateAgent.find(params[:id])      
          @estate_agents = current_user.estate_agents
          @branches = @estate_agent.branches
          @agents = @estate_agent.agents
          @properties = Property.where("estate_agent_id in (?) and status_id = ?", current_user.estate_agents.ids, @status.id )
        end
      end
    end

    def status_params
      params.require(:status).permit(:description, :colour)
    end
end
