class Post < ActiveRecord::Base
  resourcify
  attr_accessible :body, :title
end
