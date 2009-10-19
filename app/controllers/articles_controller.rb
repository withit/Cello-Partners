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
  
  def new
    @article_template = Template.find(params[:template_id])
    @article = Article.new(:author => current_user)
  end
  
  def create
    @article_template = Template.find(params[:template_id])
    @article = Article.new(params[:article])
    @article.template = @article_template
    @article.author = current_user
    if @article.save
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end
  
  private
  
  def module_name
    action_name == "show" ? "displayarticle" : "article_publishing"
  end
  
  def function_name
     action_name == "show" ? "display" : super
  end
end
