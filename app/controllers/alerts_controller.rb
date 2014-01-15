class AlertsController < ApplicationController

  def index
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @new_alerts = current_user.alerts.where(read: false)
      @read_alerts = current_user.alerts.where(read: true)
    end
  end

  def update
    puts 'Updating alert'
    alert = Alert.find(params[:id])
    alert.update_attributes(read: params[:read])
    render :json => {}
  end

  def destroy
    puts 'Deleting alert'
    alert = Alert.find(params[:id])
    alert.destroy

    @new_alerts = current_user.alerts.where(read: false)
    @read_alerts = current_user.alerts.where(read: true)

    redirect_to alerts_path
  end
end
