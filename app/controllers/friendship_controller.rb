class FriendshipController < ApplicationController
    before_action :authenticate_user!
    before_action :set_friend, only: %i[destroy update]
  
    
  
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
        flash[:success] = 'Friend request sent'
      else
        friend_obj = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
        Friendship.destroy(friend_obj.ids)
        flash[:success] = 'Friend request cancelled'
      end
      redirect_to users_path
    end
  
    def destroy
      friend_obj = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
      Friendship.destroy(friend_obj.ids)
      flash[:success] = 'Friend request cancelled'
    end
  
    private

    def friend_params
        Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
    end

    def set_current_user
      @current_user = User.find(current_user.id)
    end
  end
  