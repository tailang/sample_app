class RelationshipsController < ApplicationController
	include SessionsHelper
	before_filter :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user) #该实例方法定义在User类中
		redirect_to @user
	end

	def destroy
		@user = Relationship.find(params[:id]).followed #找到已被关注的人
		current_user.unfollow!(@user)
		redirect_to @user
	end
end