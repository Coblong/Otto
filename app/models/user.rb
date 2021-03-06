class User < ActiveRecord::Base
  has_many :estate_agents, dependent: :destroy
  has_many :area_codes, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :alerts, dependent: :destroy
	before_save { self.email = email.downcase }
  before_create :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }
  validates :properties_per_page, :numericality => {message: "Please enter a number"}
  validates :overview_weeks, :numericality => {message: "Please enter a number"}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  		format: { with: VALID_EMAIL_REGEX }, 
  		uniqueness: { case_sensitive: false }
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def active_alerts
    self.alerts.where(read: false).size
  end

  def images?
    if self.images == 0
      return "No images" 
    elsif self.images == 1
      return "Small images" 
    else
      return "Large images"
    end
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
