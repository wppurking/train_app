# -*- encoding : utf-8 -*-
module UsersHelper
  # 通过 user 的 email 获取在 gravatar 的头像
  def gravatar_for(user)
    #gravatar_id = Digest::MD5.md5()
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
