module Api
  module Entity
    class Article < Api::Entity::Base
      PERMITTED = [:title, :text]

      expose :id
      expose :title
      expose :text
      expose :user, using: Api::Entity::User
      expose :created_at do |object, options|
        object.created_at.strftime('%d/%m/%Y')
      end
      expose :comments, using: Api::Entity::Comment
      expose :can_write do |object, options|
        can? :write, object
      end
    end
  end
end