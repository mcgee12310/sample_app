module SessionsHelper
  # Logs in the given user.
  def log_in user
    session[:user_id] = user.id
    # co 3 cach de luu tru session_storage:
    # :cookie_store (default)
    # :cache_store
    # :active_record_store
    # hien tai session trong rails duoc luu o cookie (default)
    # session[:user_id] = user.id -> Rails ma hoa, ky va gan user.id vao cookie
    # trinh duyet se luu cookie do, khi request se gui kem len server
    # Rails giai ma va khoi phuc session[:user_id] de xu ly
    # LUU Y:
    # cookie toi da co 4KB khong nen luu du lieu lon
    # co the set thoi gian het han cho cookie
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end
