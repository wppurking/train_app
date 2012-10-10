# -*- encoding : utf-8 -*-
module UsersHelper
  # 通过 user 的 email 获取在 gravatar 的头像
  def gravatar_for(user, size=80, https=false)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    image_tag("http#{https ? "s://secure" : "://www"}.gravatar.com/avatar/#{gravatar_id}?s=#{size}", alt: user.name, class: 'gravatar')
  end
end
