class UsersController < ApplicationController
    before_action :set_user,                only: [:show, :edit, :update, :destroy, :must_correct_user]
    before_action :must_sign_in,            only: [:index, :edit, :update]
    before_action :must_correct_user,       only: [:edit, :update]
    before_action :must_admin_user,         only: :destroy
    before_action :signed_in_needless_togo, only: [:new, :create]
    
    def index
        @users = User.paginate(page: params[:page])
    end
    
    def new
        @user = User.new
    end

    def show
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in @user
            flash[:success] = "Welcome to the Riddle App!"
            redirect_to @user
        else
            render 'new'
        end
    end
    
    def edit  
    end
  
    def update
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    def destroy
        if current_user?(@user)
            flash[:danger] = "You kill yourself!"
            redirect_to users_url
        elsif @user.destroy
            flash[:success] = "User destroyed."
            redirect_to users_url
        end
    end
    
    private
        def set_user
            @user = User.find(params[:id])
        end
  
        def user_params
#            params.require(:user).permit!
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
        
        def must_correct_user
            redirect_to(root_path) if !current_user?(@user)
        end
        
        def must_admin_user
            redirect_to(root_path) if !current_user.admin?
        end
        
        def signed_in_needless_togo
            redirect_to(root_path) if signed_in?
        end
end