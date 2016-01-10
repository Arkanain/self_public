module Api
  module Entity
    class User < Api::Entity::Base
      expose :email
      expose :full_name do |object, options|
        "#{object.first_name} #{object.last_name}"
      end
      expose :first_name
      expose :last_name
      expose :role
    end
  end
end