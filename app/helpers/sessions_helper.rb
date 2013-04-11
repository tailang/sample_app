module SessionsHelper
	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def current_user=(user)  #被sign_in方法调用
		@current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
		#如果@current_user为空，则执行后面的，
		#if @current_user == nil
		#   @current_user = User.find_by_remember_token(cookies[:remember_token])
		#end
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in_user
 		unless signed_in?
 		   store_location
 		   redirect_to signin_path, notice: "Please sign in."  
 	   	end	
 	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.fullpath
	end
end
