class StaticPagesController < ApplicationController
  include SessionsHelper
  def home  #相当一个new方法
    if signed_in?
    @micropost = current_user.microposts.build 
    @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  	
  end

  def contact
  	
  end
end
