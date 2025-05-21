# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def edit; end

  # POST /comments
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.error_create', name: Comment.model_name.human) }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def set_commentable
    @commentable = if params[:book_id]
                     Book.find(params[:book_id])
                   elsif params[:report_id]
                     Report.find(params[:report_id])
                   else
                     redirect_back(fallback_location: root_path, alert: t('controllers.common.error_create', name: Comment.model_name.human))
                     return
                   end
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:comment)
  end

  def authorize_user!
    return if @comment.user_id == current_user.id

    redirect_to reports_path, alert: t('controllers.common.alert_unauthorized')
  end
end
