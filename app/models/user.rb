# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password #只要数据库中有 password_digest 列,在模型文件中加入 has_secure_password 方法后就能验证用户身份了。
  					  #:passwprd与:password_confirmation相同并提交后，会保存在数据库的password_digest中
  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed    #解决关注问题

  has_many :reverse_relationships, foreign_key: "followed_id",  #解决粉丝问题
        class_name: "Relationship",
        dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  #如果没有指定类名,Rails 会尝试寻找 ReverseRelationship 类,而这个类并不存在。
  #还有一点值得注意一下,在里我们其实可以省略 :source 参数,使用下面的简单方式
  #对 :followers 属性而言,Rails 会把“followers”转成单数形式,自动寻找名为 follower_id 的外键。在此我保
  #留了 :source 参数是为了保持与 has_many :followed_users 关系之间结构上的对称,你也可以选择去掉
  #它

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token  #长期session

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z0-9\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }, 
  					uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  def feed
    Micropost.from_users_followed_by(self) #为什么可以条用micropost类中的方法？？？
    # Micropost.where("user_id = ?", id) 
    # Micropost.where("user_id = ?", id) 中的问号可以确保 id 的值在传入底层的 SQL 查询语句之前做了适
    # 当的转义,避免“SQL 注入”这种严重的安全隐患。这里Micropost.from_users_followed_by(se用到的 id 属性是个整数,没什么危险,不过在 SQL 语句中
    # 引入变量之前做转义是个好习惯。
  end

  # 这些都是实例方法，在view，controller中被调用

  def following?(other_user) #判断是不是已经关注
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user) #关注某人
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)#取消关注某人
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private
  
   def create_remember_token
     self.remember_token = SecureRandom.urlsafe_base64
   end
  
end
