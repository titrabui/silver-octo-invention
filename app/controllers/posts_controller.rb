class PostsController < ApplicationController
  before_action :authorize_access_request!, only: [:create, :update, :destroy]
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all.order('created_at DESC')

    results = @posts.map do |post|
      {
        id: post.id,
        title: post.title,
        sub_title: post.sub_title,
        description: post.description,
        user: post.user,
        comments: post.comments.length,
        image_url: extract_image_from_post(post.description),
        created_at: post.created_at
      }
    end
    render json: results
  end

  # GET /posts/1
  def show
    render json: {
      id: @post.id,
      title: @post.title,
      sub_title: @post.sub_title,
      description: @post.description,
      user: @post.user,
      comments: @post.comments.length,
      image_url: extract_image_from_post(@post.description),
      created_at: @post.created_at
    }
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created, location:@post
    else
      render json: @post.errors, status: unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: unprocessable_entity
    end
  end

  # DEL /posts/1
  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :sub_title, :description)
  end

  def extract_image_from_post(description)
    image_url = nil

    if description.present?
      urls = URI.extract(description, ['http', 'https'])
      image_url = urls.first if urls.present? && urls.size
    end

    image_url
  end
end
