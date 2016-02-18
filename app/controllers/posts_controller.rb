class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index


    #remove common words from search function results, can remove these once we upgrade from pgsearch
    bad_words = {'jobs' => '', 'vacancies' => '', 'vacancy' => '', 'job' => ''}
    re = Regexp.new(bad_words.keys.map { |x| Regexp.escape(x) }.join('|'))
    if (params[:filterrific][:search_query] )
      params[:filterrific][:search_query] = params[:filterrific][:search_query].gsub(re,bad_words)
    end
    ##

    @filterrific = initialize_filterrific(
      Post,
      params[:filterrific],
      :select_options => {
        sorted_by: Post.options_for_sorted_by,
        post_category: Post.options_for_post_category,
        post_date: Post.options_for_post_date
      }
    ) or return
    @posts = @filterrific.find.page(params[:page]).per(6)

    respond_to do |format|
      format.html
      format.js
    end

  end


  # GET /posts/1
  # GET /posts/1.json
  def show
    @similar_posts = @post.similar_posts
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end





  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:category,:postpic, :contact, :content, :title, :tag_list)
  end
end
