class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
                                     :password_confirmation, :expand_notes, :show_left_nav, :show_future, :show_overview, :overview_weeks)
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
