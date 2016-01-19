class Comment < ActiveRecord::Base
  attr_accessible :text, :article_id, :user_id

  belongs_to :article
  belongs_to :user
end