require 'securerandom'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:trackable ,
         :omniauthable, :omniauth_providers => [:google_oauth2]

  before_validation :generate_session_str
  after_create :make_superadmin_for_the_first_user

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving
  
  has_many :project_users, -> { order('role asc')}, dependent: :destroy 
  has_many :projects, through: :project_users
  # has_many :lexicon_groups, dependent: :destroy
  # has_many :models,-> { order 'created_at desc' }, dependent: :destroy
  # has_many :tasks, dependent: :destroy

  def self.new_anonymous_user(name = '')
    user = User.new
    user.session_str = SecureRandom.uuid
    if name.present?
      user.name = name 
    else
      user.name = user.session_tail
    end      
    user.email = SecureRandom.uuid + '@not-exist.email'
    user.password = 'invalid_password'
    user.generate_random_ui_avatar if user.image.blank?
    user
  end

  def generate_session_str
    self.session_str = SecureRandom.uuid if self.session_str.blank?
  end

  def user_id_str
    "USER_#{self.id}_#{self.email_or_name}"
  end

  def session_tail
    if self.session_str.blank?
      self.session_str = SecureRandom.uuid
      self.save!
    end
    self.session_str[-12..-1] || self.session_str
  end 

  def session_short
    if self.session_str.blank?
      self.session_str = SecureRandom.uuid
      self.save!
    end
    "#{self.session_str[0...4]}...#{self.session_str[-6...-1]}" || self.session_str
  end

  def self.from_omniauth(auth)
    Rails.logger.debug(auth[:info])
    data = auth.info

    user = User.where(provider: auth.provider, uid: auth.uid).first

    if user.nil? 
      if data['email'].present?
        user = User.where(email: data['email']).first_or_create
      else
        user = where(provider: auth.provider, uid: auth.uid).create 
        email = "{SecureRandom.uuid}@not-exist.email"
      end
    end
    user.name = data['name'] || data['email'] if user.name.blank?
    user.image = data['image'] if data['image'].present?
    user.skip_password_validation = true
    user.provider = auth.provider
    user.uid = auth.uid
    user.expires = auth.credentials.expires
    user.expires_at = auth.credentials.expires_at
    user.refresh_token = auth.credentials.refresh_token
    user.save!
    user
  end    

  def super_admin?
    self.super_admin
  end

  def make_superadmin_for_the_first_user
    if User.where("super_admin = 1").first.nil?
      self.super_admin = true
      self.save
    end 
  end

  def valid_email?
    self.email.present? && !self.email.include?('@not-exist.email') 
  end

  def email_or_user_id
    return self.email if self.valid_email?
    self.user_id_str
  end

  def email_or_name
    return self.email if self.valid_email?
    self.name || self.session_tail
  end

  def self.find_by_email_or_user_id(id)
    p = id.match(/USER_(\d+)_(.+)/)
    if p.present?
      User.find(p[1].to_i)
    else
      User.where("email = ?", id).first
    end
  end

  def email_or_session_tail
    return self.email if self.valid_email?
    self.session_tail
  end

  def name_or_email_or_id
    self.name || self.email_or_session_tail || "User#{self.id}"
  end

  def name_and_email
    if self.name.present? && self.email.present?
      "#{self.name} (#{self.email_or_session_tail})"
    else
      self.name_or_email_or_id
    end
  end

  def image_or_default
    self.image || "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y"
  end

  def generate_random_ui_avatar
    self.image = "https://ui-avatars.com/api/?name=#{self.name || self.email_or_session_tail}&#{random_color}"
    self.save
  end

  def has_samples?
    self.projects.where("`key` = ?", 'samples').present?
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end



  def random_color
    while true
      r = rand(256)
      g = rand(256)
      b = rand(256)
      gray = (r + g + b).to_f / 3.0
      break if gray > 180
    end
    "background=#{"%02X" % r}#{"%02X" % g}#{"%02X" % b}&color=#{"%02X" % (r*0.2)}#{"%02X" % (g*0.2)}#{"%02X" % (b*0.2)}"
  end
end
