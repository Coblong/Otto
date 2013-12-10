class StatusesController < ApplicationController

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
    puts 'Creating new status'
    @status = current_user.statuses.build
  end

  def show
    @status = Status.find(params[:id])
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

  private

    def status_params
      params.require(:status).permit(:description, :colour)
    end
end
