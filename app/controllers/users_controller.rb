class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.recent
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = t("users.update.success")
      redirect_to @user
    else
      flash[:error] = t("users.update.failure")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("users.destroy.success")
      redirect_to users_path
    else
      flash[:error] = t("users.destroy.failure")
      redirect_to @user
    end
  end

  private

  def set_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("users.not_found")
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:name, :age, :phone, :email,
                                 :date_of_birth, :gender)
  end
end
