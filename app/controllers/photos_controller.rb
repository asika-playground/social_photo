class PhotosController < ApplicationController

  before_action :get_photo, :only => [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.create( photo_params )
    @photo.user = current_user

    @photo.save!

    redirect_to photos_path
  end

  def show
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      flash[:notice] = "Updated."

      redirect_to photo_path(@photo)
    else
      render :edit
    end
  end

  def destroy
    @photo.image = nil
    @photo.save!
  end

  protected

  def get_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description)
  end

end
