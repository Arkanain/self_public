module Api
  module Entity
    class Article < Api::Entity::Base
      expose :title
      expose :text, as: :description
      expose :user_id
      expose :can_read do |object, options|
        can? :read, object
      end
      expose :can_write do |object, options|
        can? :write, object
      end
    end
  end
end