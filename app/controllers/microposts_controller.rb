# encoding: utf-8
class MicropostsController < ApplicationController
include SessionsHelper

	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: :destroy
	def index
		
	end

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		if @micropost.save
			flash[:success] = "发布成功"
			redirect_to root_url
		else
			@feed_items = [] 
			# 如果发布微博失败,首页还会需要一个名为 @feed_items 的实例变量,所以提交失败时网站就无法正常运行了(你也可以运行测试来
   #          验证一下)。最简单的解决方法是,如果提交失败就把 @feed_items 设为空数组
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	def correct_user
		@micropost = current_user.microposts.find_by_id(params[:id])
		redirect_to root_url if @micropost.nil?
	end
end
