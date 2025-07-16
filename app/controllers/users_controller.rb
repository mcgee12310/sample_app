class UsersController < ApplicationController
  # BEFORE_ACTION CHAY TU TREN XUONG DUOI!!!
  before_action :logged_in_user, only: %i(index show edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.recent)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_out
      @user.send_activation_email
      flash[:info] = t("users.create.activate")
      redirect_to root_url, status: :see_other
    else
      flash[:error] = t("users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t(".success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".failure")
    end

    redirect_to users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".not_found")
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".not_logged_in")
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t(".update.forbid")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t(".not_authorized")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(User::USER_PERMIT)
  end
end
