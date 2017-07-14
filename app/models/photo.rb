class Photo < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :title, presence: true
end
