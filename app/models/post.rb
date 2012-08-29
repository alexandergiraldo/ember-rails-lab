class Post < ActiveRecord::Base
  resourcify
  attr_accessible :body, :title, :user_id
  belongs_to :user
end
