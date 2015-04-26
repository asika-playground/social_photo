class Photo < ActiveRecord::Base

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :image

  belongs_to :user

  has_many :comments, :dependent => :destroy

  has_many :user_photo_likeships, :dependent => :destroy
  has_many :likes, :through => :user_photo_likeships, :source => :user, :dependent => :destroy

  has_many :user_photo_subscribeships, :dependent => :destroy
  has_many :subscriptions, :through => :user_photo_subscribeships, :source => :user, :dependent => :destroy

  has_many :taggings
  has_many :tags, :through => :taggings

  def tag_list
    self.tags.map{|t| t.name}.join(",")
  end

  def tag_list=(value)
    Rails.logger.debug("value=#{value}")

    tags = value.split(",").map do |tagname|
      tagname = tagname.strip
      Tag.find_by_name(tagname) || Tag.create(:name => tagname)
    end
    self.tag_ids = tags.map{|t| t.id}

    Rails.logger.debug(self.tag_ids)
  end

  def liked_by?(user)
    self.like_ids.include?(user.id)
  end

  def subscribed_by?(user)
    self.subscription_ids.include?(user.id)
  end

  def can_modify_by?(user)
    (self.user == user) || (self.user.admin?)
  end
end
