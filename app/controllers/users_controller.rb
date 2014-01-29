class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :new, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    puts 'Showing user'
    @user = current_user
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    puts 'Update the user'
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash[:error] = "Unable to update user"
      render 'show'
    end
  end

  def update_preferences
    puts 'Updating preferences'
    user = User.find(params[:user_id])
    if params[:overview_weeks].to_i > 0
      puts 'Updating overview weeks'
      user.overview_weeks = params[:overview_weeks].to_i      
    end
    user.expand_notes = params[:expand_notes] == "true"
    user.show_images = params[:show_images] == "true"    
    user.save()
    show_today_only(params[:show_today_only])
    render :json => user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Otto!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private

    def user_params
      puts 'Updating user'
      puts 'params = ' + params.to_yaml
      puts 'user params = ' + params[:user].to_yaml
      params[:user].delete(:password) if params[:user][:password].blank?
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation, :expand_notes, :show_left_nav, :show_future, :show_overview, :overview_weeks, :show_images)
    end

    # Before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
