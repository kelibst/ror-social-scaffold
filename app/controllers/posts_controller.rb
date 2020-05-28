class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def friends(user)
    friend1 = Friendship.where(user_id: current_user.id, friend_id: user, confirmed: true)
    friend2 = Friendship.where(user_id: user, friend_id: current_user.id, confirmed: true)
    user if friend1.exists? || friend2.exists? || user == current_user.id
  end

  def timeline_posts
    @all_posts ||= Post.all.ordered_by_most_recent.includes(:user)
    @timeline_posts = []

    @all_posts.each do |post|
      @timeline_posts.push(post) if post.user_id == friends(post.user_id)
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
