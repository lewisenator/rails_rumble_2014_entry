# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'test@example'
  TEMP_EMAIL_REGEX = /\Atest@example/

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  #validates_presence_of :first_name, :last_name

  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

 #  def self.from_omniauth(auth)
	#   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	#     user.email = auth.info.email
	#     user.password = Devise.friendly_token[0,20]
	#     user.name = auth.info.name   # assuming the user model has a name
	#     user.image = auth.info.image # assuming the user model has an image
	#   end
	# end

	# def self.new_with_session(params, session)
 #    super.tap do |user|
 #      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
 #        user.email = data["email"] if user.email.blank?
 #      end
 #    end
 #  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    Rails.logger.error "auth result: #{auth.to_s}"
    puts "auth result: #{auth.to_s}"

    identity = Identity.find_for_oauth(auth)
    identity.auth = auth.to_s
    identity.save!

    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          name: auth.info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
