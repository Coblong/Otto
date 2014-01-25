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

  def read_all
    puts 'read all alerts'
    current_user.alerts.each do |a| 
      a.update_attributes(read: true)
    end
    
    render :json => {}
  end

  def unread_all
    puts 'unread all alerts'
    current_user.alerts.each do |a| 
      a.update_attributes(read: false)
    end
    
    render :json => {}
  end

  def delete_read
    puts 'delete read alerts'
    current_user.alerts.where(read: true).each do |a| 
      a.destroy
    end
    
    render :json => {}
  end

  def delete_unread
    puts 'delete unread alerts'
    current_user.alerts.where(read: false).each do |a| 
      a.destroy
    end

    render :json => {}
  end
end
