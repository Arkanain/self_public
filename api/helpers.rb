module Api
  module Helpers
    def warden
      env['warden']
    end

    def authenticated
      return true if warden.authenticated?
      params[:auth_token] && @user = User.where(authentication_token: params[:auth_token]).first
    end

    def current_user
      warden.user || @user
    end

    def permission_denied!(object, method)
      error!("550 Permission denied", 550) unless can? method, object
    end

    def authorized!
      error!("401 Unauthorized", 401) unless current_user
    end

    def present(*args)
      args[1].merge!(current_user: current_user)
      super *args
    end

    def can?(method, object)
      ::Ability.new(current_user).can?(method, object)
    end
  end
end