# encoding: utf-8
class SessionsController < ApplicationController
 protect_from_forgery
 include SessionsHelper  #helper的方法可以在views中自动使用，但是在controller中要include

	def new
		
	end

	def create
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password])
			sign_in user
			#redirect_to user
			redirect_back_or user #跳转到登入前的页面或者user面，定义在helper中
		else
			flash.now[:error] = "邮箱或密码错误"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
