class Micropost < ActiveRecord::Base
  attr_accessible :content #:user_id不能被外界访问

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  default_scope order: 'microposts.created_at DESC' #倒序排列

  # def self.from_users_followed_by(user) #被user.rb下的feed调用
  	# followed_user_ids = user.followed_user_ids#等于 user.followed_users.map(&:id)
  											  #得到被关注者的全部id。
  	#where("user_id IN (?) OR user_id = ?",followed_user_ids,user)#先写入内存再创建，效率不高
  	# where("user_id IN (:followed_user_ids) OR user_id = :user_id",
  		   # followed_user_ids: followed_user_ids, user_id: user)
  # end

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships
  	                     WHERE follower_id = :user_id"
  	where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", #定义一个：user_id,后面知名其值为user.id
  		   user_id: user.id) 
  end
end
