class PhotosController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :like, :unlike]
  before_action :get_photo, :only => [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all
    @comment = Comment.new
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.create( photo_params )
    @photo.user = current_user

    if @photo.save
      flash[:notice] = "Created."

      redirect_to photos_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @photo.can_modify_by?(current_user)
      if @photo.update(photo_params)
        flash[:notice] = "Updated."

        redirect_to photo_path(@photo)
      else
        render :edit
      end

    else
      flash[:alert] = "No Permission."

      redirect_to photo_path(@photo)
    end
  end

  def destroy
    if @photo.can_modify_by?(current_user)
      @photo.destroy
    else
      flash[:alert] = "No Permission."

      redirect_to photo_path(@photo)
    end

    redirect_to photos_path
  end

  def like
    @photo = Photo.find(params[:photo_id])
    current_user.likes << @photo

    redirect_to photo_path(@photo)
  end

  def unlike
    @photo = Photo.find(params[:photo_id])
    current_user.likes.delete(@photo)

    redirect_to photo_path(@photo)
  end

  protected

  def get_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description, :tag_list)
  end

end
