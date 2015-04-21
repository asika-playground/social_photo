class Photo < ActiveRecord::Base

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  belongs_to :user

  has_many :likes
  has_many :comments

  def liked_by?(user)
    users_like = self.likes.map {|l| l.user_id}

    users_like.include?(user.id)
  end

  def can_modify_by?(user)
    (self.user == user) || (self.user.admin?)
  end
end
