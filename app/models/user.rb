class User < ActiveRecord::Base
  has_many :photos
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  mount_uploader :avatar, AvatarUploader

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.new(
        name:     auth.extra.raw_info.name,
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        image_url:   auth.info.image,
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end


  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    unless user
      user = User.new(
        name:     auth.info.nickname,
        image_url: auth.info.image,
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  class Users::RegistrationsController < Devise::RegistrationsController
    def build_resource(hash=nil)
      hash[:uid] = User.create_unique_string
      super
    end
  end

  # omniauthでサインアップしたアカウントのユーザ情報の変更出来るようにする
  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end

end
