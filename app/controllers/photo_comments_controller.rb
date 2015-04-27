class PhotoCommentsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_action :get_photo

  def new
    @comment = @photo.comments.build
  end

  def create
    @comment = @photo.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|

      if @comment.save
        if @photo.subscribed_by?(current_user)
          UserMailer.notify_comment(current_user, @comment).deliver_later!
        end

        format.html do
          flash[:notice] = "Replied."
          redirect_to photo_path(@photo)
        end

        format.js
      else
        format.html {render :new}
        format.js {render :js => "alert('Reply failed.');"}
      end
    end
  end

  def edit
    @comment = @photo.comments.find(params[:id])
  end

  def update
    @comment = @photo.comments.find(params[:id])

    if @comment.update(comment_params)
      flash[:notice] = "Comment Edited."

      redirect_to photo_path(@photo)
    else
      render :edit
    end
  end

  def destroy
    @comment = @photo.comments.find(params[:id])

    respond_to do |format|

      format.html do
        if @comment.can_modify_by?(current_user)
          @comment.destroy

          flash[:alert] = "Comment Deleted."
        else
          flash[:alert] = "No Permission to Delete!!"
        end
        redirect_to photo_path(@photo)
      end

      format.js do
        if @comment.can_modify_by?(current_user)
          @comment.destroy
        end
      end
    end
  end

  protected

  def get_photo
    @photo = Photo.find(params[:photo_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end
