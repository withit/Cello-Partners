class ArticlesController < ApplicationController
  def index
    @articles=  current_user.articles.all(:conditions => {:published => true})
  end
  
  def edit
    @article = current_user.articles.find(params[:id])
  end
  
  def update
    @article = current_user.articles.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def show
    @article = current_user.articles.find(params[:id])
  end
end
