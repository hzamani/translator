class Post < ActiveRecord::Base
  attr_accessible :author, :content, :title
  translates :title, :content
end
