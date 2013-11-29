class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def new    
  end

  def validate
    if signed_in?
      render json: current_user
    else
      render :nothing => true, :status => :service_unavailable
    end
  end

  def quietly
    puts 'Logging in with ' + params[:email].to_s + ' : ' + params[:pwd] 
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:pwd])
      sign_in user
      render json: user
    else
      render :nothing => true, :status => :service_unavailable
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
