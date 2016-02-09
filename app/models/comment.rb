class Comment < ActiveRecord::Base
  attr_accessible :text, :article, :article_id, :user, :user_id

  belongs_to :article
  belongs_to :user
end
