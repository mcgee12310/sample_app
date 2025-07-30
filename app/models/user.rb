class User < ApplicationRecord
  has_secure_password
  # cung cap xac thuc mat khau cho model user
  # tu them cac truong:
  # password: khong luu vao csdl
  # password_confirmation
  # password_digest: luu password vao csdl duoi dang hash
  # xac thuc mat khau bang authenticate(password)

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  NAME_MAX_LENGTH = 50
  EMAIL_MAX_LENGTH = 255
  PASSWORD_MIN_LENGTH = 3
  PASSWORD_RESET_EXPIRED = 2 # hours

  USER_PERMIT = %i(
    name
    email
    date_of_birth
    gender
    password
    password_confirmation
  ).freeze

  GENDERS = {
    male: "male",
    female: "female",
    other: "other"
  }.freeze

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  scope :recent, ->{order(created_at: :desc)} # thu tu giam dan

  validates :name, presence: true, length: {maximum: NAME_MAX_LENGTH}
  validates :email, presence: true, length: {maximum: EMAIL_MAX_LENGTH},
format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  # validation cua email se khong phan biet CHU HOA va chu thuong
  validate :date_of_birth_must_be_within_last_100_years
  validates :password, presence: true, length: {minimum: PASSWORD_MIN_LENGTH},
allow_nil: true

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    return false if reset_sent_at.nil?

    reset_sent_at < PASSWORD_RESET_EXPIRED.hours.ago
  end

  def feed
    Micropost.relate_post(following_ids << id).includes(:user,
                                                        image_attachment: :blob)
  end

  def follow other_user
    # Follows a user.
    following << other_user
  end

  def unfollow other_user
    # Unfollows a user.
    following.delete other_user
  end

  def following? other_user
    # Returns if the current user is following the other_user or not
    following.include? other_user
  end

  private

  def downcase_email
    email.downcase!
  end
  # downcase_email se chay truoc khi luu user vao csdl
  # lam cho tat ca ky tu cua email thanh chu thuong

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def date_of_birth_must_be_within_last_100_years
    return if date_of_birth.blank?

    if date_of_birth < 100.years.ago.to_date || date_of_birth > Time.zone.today
      errors.add(:date_of_birth, :invalid_range)
    end
  end
end
