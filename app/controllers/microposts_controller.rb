class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_micropost, only: :destroy
  before_action :correct_user, only: :destroy

  # POST (/:locale)/microposts(.:format)
  def create
    @micropost = current_user.microposts.build micropost_params

    @micropost.image.attach params.dig(:micropost, :image)

    handle_create
  end

  # DELETE (/:locale)/microposts/:id(.:format)
  def destroy
    if @micropost.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".failure")
    end

    redirect_to request.referer || root_url
  end

  private

  def load_micropost
    @micropost = current_user.microposts.find_by id: params[:id]
  end

  def correct_user
    return if @micropost

    flash[:danger] = t(".invalid")
    redirect_to request.referer || root_url
  end

  def handle_create
    if @micropost.save
      flash[:success] = t(".success")
      redirect_to root_url
    else
      flash[:danger] = t(".failure")
      @pagy, @feed_items = pagy current_user.feed

      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def micropost_params
    params.require(:micropost).permit(Micropost::MICROPOST_PERMIT)
  end
end
