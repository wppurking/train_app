# -*- encoding : utf-8 -*-
module ApplicationHelper

  def title(title=nil)
    title ? title : "Train App"
  end
end
