class Article < ActiveRecord::Base
  attr_accessible :title, :text, :user_id

  belongs_to :user
  has_many :comments
end