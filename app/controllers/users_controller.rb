class UsersController < ApplicationController
    
    before_action :logged_in_user, only: [:index]

    def index
        @users = User.paginate(page: params[:page],:per_page => 10)
    end
    
    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.order(created_at: :desc)
    end


   def new
    @user = User.new
   end
    
    def create
        @user = User.new(user_params)
        
        if @user.save
            flash[:success] = "Welcome to the Sample App!"
            redirect_to @user
        else
            render 'new'
        end
    end
    
   private
#userキーが存在するか検証、するならparams[:user]のうち以上のカラムの値を受け取る
    def user_params
        params.require(:user).permit(:name, :email, :password,
                             :password_confirmation)
     
    end
end


