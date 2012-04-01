# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  password_digest    :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#
class User < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy
	before_save :create_remember_token
	
	validates :name, presence:true, length: { maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
	validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }
	before_save :encrypt_password
	 
	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def feed
    Micropost
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
	
	private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
