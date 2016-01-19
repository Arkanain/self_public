module Api
  module Helpers
    def current_user
      @current_user ||= User.where(authentication_token: params[:auth_token]).first
    end

    def permission_denied!(object, method)
      error!("550 Permission denied", 550) unless can? method, object
    end

    def authorized!
      error!("401 Unauthorized", 401) unless current_user
    end

    # Rewrite default method for using cancan functionality
    def present(*args)
      args[1].merge!(current_user: current_user)
      super *args
    end

    def can?(method, object)
      ability.can?(method, object)
    end

    # For PUT and POST requests .Only permitted attributes will be saved.
    def permitted_attributes!(entity)
      params.slice(*entity::PERMITTED)
    end

    private

    def ability
      @ability ||= ::Ability.new(current_user)
    end
  end
end