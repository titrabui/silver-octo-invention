class CommentsController < ApplicationController
  before_action :authorize_access_request! only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]
  before_action :set_post, only: [:create, :update, :destroy]

  # GET /comments
  def index
    @comments = comment.all.order('created_at DESC')

    render json: @comments
  end

  # comment /comments
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      render json: @comment, status: :created, location:@comment
    else
      render json: @comment.errors, status: unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: unprocessable_entity
    end
  end

  # DEL /comments/1
  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
