class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates_presence_of :friendly_id
  validates_uniqueness_of :friendly_id

  before_validation :setup_friendly_id

  has_many :photos, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_many :user_photo_likeships, :dependent => :destroy
  has_many :likes, :through => :user_photo_likeships, :source => :photo, :dependent => :destroy

  has_many :user_photo_subscribeships, :dependent => :destroy
  has_many :subscriptions, :through => :user_photo_subscribeships, :source => :photo, :dependent => :destroy

  def admin?
    # self.role == "admin"
    false
  end

  def to_param
    self.friendly_id
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def setup_friendly_id
    if self.friendly_id.blank?
     self.friendly_id = SecureRandom.hex(8)
     self.save!
    end
  end

end
