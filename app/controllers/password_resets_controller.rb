class PasswordResetsController < ApplicationController
  PASSWORD_RESET_PERMIT = %i(
    password
    password_confirmation
  ).freeze

  before_action :load_user, :valid_user,
                :check_expiration, only: %i(edit update)

  # POST (/:locale)/password_resets
  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(".notice")
      redirect_to root_url
    else
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  # GET (/:locale)/password_resets/:id/edit(.:format)
  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update user_params.merge(reset_digest: nil)
      log_in @user
      flash[:success] = t(".success")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("users.not_found")
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("users.not_activated")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".expired")
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit PASSWORD_RESET_PERMIT
  end
end
