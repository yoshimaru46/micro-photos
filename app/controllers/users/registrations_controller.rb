class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end

  def destroy
    # ユーザーに紐付く投稿の削除
    Photo.where(user_id:current_user.id).delete_all
    super
  end

end
