class SitemapController < ApplicationController


  def index
    @host = "#{request.protocol}#{request.host}"
    @posts = Post.all
  end
end