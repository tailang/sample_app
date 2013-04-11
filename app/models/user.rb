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
    Micropost.where("user_id = ?", id) 
    # Micropost.where("user_id = ?", id) 中的问号可以确保 id 的值在传入底层的 SQL 查询语句之前做了适
    # 当的转义,避免“SQL 注入”这种严重的安全隐患。这里用到的 id 属性是个整数,没什么危险,不过在 SQL 语句中
    # 引入变量之前做转义是个好习惯。
  end

  private
  
   def create_remember_token
     self.remember_token = SecureRandom.urlsafe_base64
   end
  
end
