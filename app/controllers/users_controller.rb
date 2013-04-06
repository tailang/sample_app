class UsersController < ApplicationController
  
 def show
  	@user = User.find(params[:id])
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
		flash[:success] = "welcome to the sample app"
		redirect_to @user

	else
	  render 'new'
	end
 end
end

