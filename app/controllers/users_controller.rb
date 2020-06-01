class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user, only: %i[show index destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @mutual = mutual_friends(current_user, @user)
    @posts = @user.posts.ordered_by_most_recent
  end

  def req_init
    set_friendship = Friendship.where(user_id: params[:id], friend_id: current_user.id, confirmed: false)
    if set_friendship.exists?
      set_friendship.update_all(confirmed: true)

      redirect_to users_path, notice: 'Friend request is confirmed!'
      return
    end
    new_friendship = Friendship.where(user_id: current_user.id, friend_id: params[:id]).exists?
    if !new_friendship
      send_request(current_user.id, params[:id])
    else
     cancel_request(current_user.id, params[:id])
    end
  end

  def send_request(current_user_id, friend_id)
    friend = Friendship.new(user_id: current_user_id, friend_id: friend_id, confirmed: false)
    friend.save
    redirect_to users_path, notice: 'Friend request is sent!'
  end

  def cancel_request(current_user, friend_id)
    friend = Friendship.where(user_id: current_user, friend_id:friend_id).select('id')
    Friendship.destroy(friend.ids)
    redirect_to users_path, notice: 'Friend request is cancelled!'
  end

  def mutual_friends(current_user, user)
    counter = 0
    user.friendships.confirmed.each do |_mutual|
      counter += 1 if current_user.friendships.isFriends(current_user, user)
    end
    counter
  end

  def destroy_req
    friend = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    friend_inverse = Friendship.where(user_id: current_user.id, friend_id: params[:id])
    Friendship.destroy(friend.ids)
    Friendship.destroy(friend_inverse.ids)
    redirect_to users_path, notice: 'Friend request is deleted!'
  end

  private

  def set_current_user
    @current_user = User.find(current_user.id)
  end
end
