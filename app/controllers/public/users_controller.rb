class Public::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def mypage
    current_user.get_image
    @posts = current_user.posts.includes(:comments).page(params[:post_page]).per(5)
    @comments = current_user.comments.page(params[:comment_page]).per(5)
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorites.includes(:post)
  end
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @posts = @user.posts  
  end

  # GET /users/:id/edit
  def edit
    @user = current_user
    redirect_to root_path, alert: 'Access denied.' unless @user == current_user
  end

  # PATCH /users/:id
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User profile was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  # Callback to set user
  def set_user
    @user = User.find(params[:id])
  end

  # Strong parameters for user
  def user_params
    params.require(:user).permit(:name, :email, :user_image,)
  end
end