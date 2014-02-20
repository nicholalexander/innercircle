class User < ActiveRecord::Base
	has_attached_file :avatar, :styles => { :thumb => "75x75>" }
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  has_many :photos
  has_many :comments
  has_secure_password

end