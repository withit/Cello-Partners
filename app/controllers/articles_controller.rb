class ArticlesController < ApplicationController
  def index
    @articles=  Article.all(:conditions => {:published => true})
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def show
    @article = Article.find(params[:id])
  end
end
