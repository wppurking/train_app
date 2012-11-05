class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    # 使用 respond_to 来支持同一个请求的不同类型的返回响应,
    # 1. 可以接受一个 &block 来执行一部分代码(例如 redirect_to)
    # 2. 可以不需要 &block, 如果默认的 html 一样, 直接跳转到模板
    respond_to do |fmt|
      fmt.html { redirect_to @user }
      # 只可以使用 fmt.js  而不可以使用 fmt.coffee ,但 rails 还是会根据 Asset Pipeline 来完成 js 文件的渲染
      fmt.js
    end
  end

  def destory
    @user = User.find(params[:followed_id])
    current_user.unfollow(@user)
    respond_to do |fmt|
      fmt.html { redirect_to @user }
      fmt.js
    end
  end

end
