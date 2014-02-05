class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :edit, :update]
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
      user.overview_weeks = params[:overview_weeks].to_i      
    end
    user.expand_notes = params[:expand_notes] == "true"
    user.images = params[:images].to_i
    user.save()
    show_today_only(params[:show_today_only])
    render :json => user
  end

  def create
    @user = User.new(new_user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Ottor system!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private

    def new_user_params
      puts 'Crteating user'
      params[:user][:expand_notes] = false
      params[:user][:show_left_nav] = true
      params[:user][:show_future] = false
      params[:user][:show_overview] = true
      params[:user][:properties_per_page] = 10
      params[:user][:overview_weeks] = 2
      params[:user][:images] = 0
      user_params
    end

    def user_params
      puts 'Updating user'
      params[:user].delete(:password) if params[:user][:password].blank?
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation, :expand_notes, :show_left_nav, :show_future, :show_overview, :properties_per_page, :overview_weeks, :images)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
