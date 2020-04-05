class HomeController < ApplicationController
  def index
    @top_menu = "home"
  end

  def sitemap
  end
  
  def about
    @top_menu = "about"
  end
  def proxy
    url = params[:url]
    response = HTTParty.get(url)
    render plain: response
  end
end
