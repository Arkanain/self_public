module Api
  module Entity
    class Comment < Api::Entity::Base
      PERMITTED = [:text, :user_id, :article_id]

      expose :id
      expose :text
      expose :user, using: Api::Entity::User
    end
  end
end