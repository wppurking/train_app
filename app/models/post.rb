# -*- encoding : utf-8 -*-
class Post < ActiveRecord::Base
  attr_accessible :content

  default_scope order("created_at DESC")

  validates :content, presence: true

  belongs_to :user

end
