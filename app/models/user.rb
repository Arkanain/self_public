class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :registerable, :recoverable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, :token_authenticatable

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :role, :authentication_token

  has_many :articles

  ROLES = %w{admin writer}

  ROLES.each do |role|
    define_method("#{role}?") { role == self.role }
  end

  before_save :ensure_authentication_token
  before_save :assign_role
  before_save :assign_name

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def assign_role
    self.role = 'writer' if self.role.blank?
  end

  def assign_name
    self.first_name = self.email.slice(/^([\w\.]*)/) if self.first_name.blank?
    self.last_name = self.email.slice(/^([\w\.]*)/) if self.last_name.blank?
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end