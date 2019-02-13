class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
      #binding.pry
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
      #binding.pry
    @user = current_user.following_relationships.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end