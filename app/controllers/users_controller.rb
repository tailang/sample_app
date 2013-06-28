# encoding: utf-8
class UsersController < ApplicationController

 include SessionsHelper
 before_filter :signed_in_user, only: [:index, :edit, :update] #控制权限只有登入才能修改
 before_filter :correct_user, only: [:edit, :update]  #只能修改自己的信息
 before_filter :admin_user, only: :destroy #判断是不是管理员

 def index
 	#@users = User.all
 	@users = User.paginate(page: params[:page])
 end

 def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page])
 end
  
 def new
 	@user = User.new
 end

 def create
	@user = User.new(params[:user])
	#提交表单后，rails会构建一个名为user的Hash，其键值是imput标签的那么属性值，
	#键对应的值是用户填写的字段文本。等同与
	#@user = User.new(name: "xxx",email: "xxx",
	#	              password: "xxx",password confirmation: "xxx")
	if @user.save
		sign_in @user
		flash[:success] = "欢迎加入恩昂~"
		redirect_to @user

	else
	  render 'new'
	end
 end

 def edit
 	#@user = User.find(params[:id]) correct_user方法已经使用该方法
 end

 def update
 	@user = User.find(params[:id])
 	if @user.update_attributes(params[:user])
 		flash[:success] = "更新成功"
 		sign_in @user
 		redirect_to @user
 	else
 		render 'edit'
 	end	
 end

 	def destroy
 		User.find(params[:id]).destroy
 		flash[:success] = "用户注销成功"
 		redirect_to users_path
 	end

 	def following
 		@title = "Following"
 		@user = User.find(params[:id])
 		@users = @user.followed_users.paginate(page: params[:page])
 		render 'show_follow'
 	end

 	def followers
 		@title = "Followers"
 		@user = User.find(params[:id])
 		@users = @user.followers.paginate(page: params[:page])
 		render 'show_follow'
 	end

 private

 	

 	def correct_user
 		@user = User.find(params[:id])
 		redirect_to(root_path) unless current_user?(@user) 
 	end

 	def admin_user
 		redirect_to(root_path) unless current_user.admin?	
 	end

end

