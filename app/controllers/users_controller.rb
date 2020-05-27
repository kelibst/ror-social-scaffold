class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: %i[show index destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def req_init
    set_friendship = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    if set_friendship.exists?
      set_friendship.update_all(confirmed: true)
      redirect_to users_path
      return
    end
    new_friendship = Friendship.where(user_id: current_user.id, friend_id: params[:id]).exists?
    if !new_friendship
      friend_obj = Friendship.new(user_id: current_user.id, friend_id: params[:id], confirmed: false)
      friend_obj.save
    else
      friend_obj = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
      Friendship.destroy(friend_obj.ids)
    end
    redirect_to users_path
  end

  def destroy
    friend_obj = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
    Friendship.destroy(friend_obj.ids)
  end

  private

  def set_current_user
    @current_user = User.find(current_user.id)
  end
end
