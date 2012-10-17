# -*- encoding : utf-8 -*-
class PostsController < ApplicationController

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "评论成功"
      redirect_to root_url
    else
      render 'application/home'
    end
  end

end
