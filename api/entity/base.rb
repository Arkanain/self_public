module Api
  module Entity
    class Base < Grape::Entity
      include CanCan::Ability

      def can?(method, object)
        ::Ability.new(options[:current_user]).can?(method, object)
      end
    end
  end
end