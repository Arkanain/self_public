module Api
  module Entity
    class Article < Api::Entity::Base
      expose :id
      expose :title
      expose :text
      expose :user_id
      expose :can_write do |object, options|
        can? :write, object
      end
    end
  end
end