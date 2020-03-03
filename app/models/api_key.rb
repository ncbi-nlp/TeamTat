class ApiKey < ApplicationRecord
  belongs_to :user
  validates :key, presence: true

  def generate_key
    self.key = SecureRandom.urlsafe_base64(32)
  end

  def user_email
    user.try(:email)
  end

  def user_email=(email)
    self.user = User.find_by(email: email) if email.present?
  end
end
