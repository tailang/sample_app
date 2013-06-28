#encoding: utf-8
module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token#cookies是一个hash，cookies[:remember_token]本身也是一个hash，他包括value和expires，后者指明了cookies失效的时间，这里使用permanent方法则设为20年后
		self.current_user = user #会自动转换成current_user=(...),注意这里是一个方法，不是一个变量
	end

	def current_user=(user)  #被sign_in方法调用,获取当前的用户
		@current_user = user
	end

	def signed_in? #判断是否已经登入
		!current_user.nil?
	end

	def current_user  #用来获得@current_user这个变量，就是来解决attr_accessor,如果只用@current_user转到其他的页面，session会失效
		              #在其他地方可以用current_user这个方法，访问@current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		#如果@current_user为空，则执行后面的，
		#if @current_user == nil
		#   @current_user = User.find_by_remember_token(cookies[:remember_token])
		#end
	end

	def sign_out #退出后，当前用户为nil，并且删除cookies
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user?(user) #判断是不是当前的用户
		user == current_user
	end

	def signed_in_user  #判断是否登录，如果没有保存当前url，跳转到登录页。在usercontroller中作为before_filter
 		unless signed_in?
 		   store_location
 		   redirect_to signin_path, notice: "请登录"  
 	   	end	
 	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default) #如果存在session[:return_to]，则跳转到session[:return_to]。否则跳转到制定的default
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.fullpath #储存登入前的url，以便登入后，再转到该页，而不是user/id页
											   #session与request.fullpath由rails提供
	end
end
