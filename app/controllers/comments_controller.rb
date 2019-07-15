class CommentsController < ApplicationController
  before_action :authorize_access_request!, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]
  before_action :set_post, only: [:comments_by_post, :create]

  # GET /comments
  def index
    @comments = comment.all.order('created_at DESC')

    render json: @comments
  end

  # GET /comments_by_post/:post_id
  def comments_by_post
    @comments = @post.comments.where(parent_id: nil).order('created_at DESC')

    results = @comments.map do |comment|
      {
        id: comment.id,
        post_id: comment.post.id,
        author: {
          id: comment.user.id,
          email: comment.user.email,
          display_name: comment.user.display_name,
          avatar: comment.user.avatar.url
        },
        content: comment.content,
        replies: comment.replies,
        likes: comment.likes,
        created_at: comment.created_at
      }
    end

    render json: results
  end

  # GET /replies/:id
  def comments_by_parent
    parent_id = params[:id]
    comments = Comment.where(parent_id: parent_id)

    results = comments.map do |comment|
      { 
        id: comment.id,
        post_id: comment.post.id,
        author: {
          id: comment.user.id,
          email: comment.user.email,
          display_name: comment.user.display_name,
          avatar: comment.user.avatar.url
        },
        content: comment.content,
        replies: comment.replies,
        likes: comment.likes,
        created_at: comment.created_at
      }
    end

    render json: results
  end

  # POST /comments
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      if params[:parent_id].present?
        parent_comment = @post.comments.find(params[:parent_id])
        parent_comment.update({ replies: parent_comment.replies + 1 })
      end

      render json: @comment, status: :created, location:@comment
    else
      render json: @comment.errors, status: unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update({ content: params[:content] })
      render json: @comment
    else
      render json: @comment.errors, status: unprocessable_entity
    end
  end

  # DEL /comments/1
  def destroy
    parent = @comment.parent
    if @comment.destroy
      parent.update({ replies: parent.replies - 1 })
    end
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:parent_id, :content)
  end
end
