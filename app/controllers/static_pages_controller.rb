class StaticPagesController < ApplicationController
  def home
     if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed_items.paginate(page: params[:page]).order(created_at: :desc)
    end
  end
end