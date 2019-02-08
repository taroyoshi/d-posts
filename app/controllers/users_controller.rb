class UsersController < ApplicationController
    def show # 追加
        @user = User.find(params[:id])
    end


   def new
    @user = User.new
   end
    
    def create
        @user = User.new(user_params)
        if @user.save
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
