class Comment < ActiveRecord::Base

  belongs_to :photo
  belongs_to :user

  validates_presence_of :content

  def can_modify_by?(user)
    user && ( (self.user == user) || (self.user.admin?) )
  end

end
