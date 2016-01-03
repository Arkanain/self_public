module UsersHelper
  def roles_for_select
    User::ROLES.map { |role| [role, role] }
  end
end