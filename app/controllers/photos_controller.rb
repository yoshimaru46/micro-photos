class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all
  end

  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user_id = current_user.id
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photos_path, notice: '作成しました！' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to photos_path, notice: '更新しました！' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: '削除しました！' }
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :content, :image, :user_id)
  end
end
