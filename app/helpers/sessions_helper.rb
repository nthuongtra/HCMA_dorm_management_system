module SessionsHelper
  def log_in user
    session[:user_id] = user.id
    session[:role] = user.class.name
  end

  def current_user
    if user_id = session[:user_id]
      if session[:role] == 'Manager'
        @current_user = Manager.find_by id: session[:user_id]
      elsif session[:role] == 'Student'
        @current_user = Student.find_by id: session[:user_id]
      end     
    elsif user_id = cookies.signed[:user_id]
      if cookies.signed[:role] == 'Manager'
        @user = Manager.find_by(id: user_id)
      elsif cookies.signed[:role] == 'Student'
        @user = Student.find_by(id: user_id)
      end
      if @user && @user.authenticated?(:remember, cookies.signed[:remember_token])
        log_in @user
        @current_user = @user
      end
    end
    return @current_user
  end

  def logged_in?
    current_user.present?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:role)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete :user_id
    session.delete :role
    @current_user = nil
  end

  # def store_location
  #   session[:forwarding_url] = request.original_url if request.get?
  # end

  def remember(user)
    user.remember #tao remember digest luu vao db va remember token vao cookie
    cookies.signed[:user_id] = { :value => user.id, :expires => 240.hour.from_now} #luu vao cookie id da bi ma hoa qua ham signed, k con la id ban dau nua
    cookies.signed[:role] = { :value => user.class.name, :expires => 240.hour.from_now}
    cookies.signed[:remember_token] = { :value => user.remember_token, :expires => 240.hour.from_now}
  end

  def location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  # def find_student_by_student_id_number
  #   return Student.find_by student_id_number: params[:student_session][:student_id_number].downcase
  # end

  def logged_in_manager?
    return true if logged_in? && current_user.class.name == "Manager"
  end

  def logged_in_student?
    return true if logged_in? && current_user.class.name == "Student"
  end

  def logged_in_student
    return if logged_in? && current_user.class.name == "Student"

    redirect_to "/student/login"
  end

  def logged_in_manager
    return if logged_in? && current_user.class.name == "Manager"

    redirect_to "/manager/login"
  end
end
