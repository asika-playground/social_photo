class PhotosController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :like, :unlike]
  before_action :get_photo, :only => [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all.order("created_at DESC")

    @photo = Photo.new
    @comment = Comment.new
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.create( photo_params )
    @photo.user = current_user

    if @photo.save
      respond_to do |format|
        format.html do
          # flash[:notice] = "Created."
          redirect_to photos_path
        end
        # format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :js => "alert('Reply failed.');" }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
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
      @photo_id = @photo.id
      @photo.destroy

      respond_to do |format|
        format.html { redirect_to photos_path }
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "No Permission."
          redirect_to photo_path(@photo)
        end
        format.js { render :js => "alert('No Permission.');" }
      end
    end


  end

  def toggle_like
    @photo = Photo.find(params[:photo_id])

    @like = true
    if @photo.liked_by?(current_user)
      current_user.likes.delete(@photo)
      @like = false
    else
      current_user.likes << @photo
    end

    respond_to do |format|
      format.html { redirect_to photo_path(@photo) }
      format.js
    end
  end

  def toggle_subscribe
    @photo = Photo.find(params[:photo_id])

    @like = true
    if @photo.subscribed_by?(current_user)
      current_user.subscriptions.delete(@photo)
      @like = false
    else
      current_user.subscriptions << @photo
    end

    respond_to do |format|
      format.html { redirect_to photo_path(@photo) }
      format.js
    end
  end


  protected

  def get_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image, :description, :tag_list)
  end

end
