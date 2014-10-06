class UsersController < ApplicationController
    before_action :set_user,          only: [:show]
    def new
        @page_title = " | Sign up"
        @user = User.new
    end

    def show
        @page_title = " | #{@user.name}"
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Welcome to the Riddle App!"
            redirect_to @user
        else
            @page_title = " | Sign up"
            render 'new'
        end
    end
  
    private
        def set_user
            @user = User.find(params[:id])
        end
  
        def user_params
      #      params.require(:user).permit!
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
end